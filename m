Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BAA45A0A2
	for <lists+live-patching@lfdr.de>; Tue, 23 Nov 2021 11:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhKWKwP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Nov 2021 05:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbhKWKwP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Nov 2021 05:52:15 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E67C061574
        for <live-patching@vger.kernel.org>; Tue, 23 Nov 2021 02:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G+Itha3x00paVlMisZhIHG3N19FzBoZIEhci6XKqk20=; b=j0Ks4hw+UUsKloTrVDWNPGARJn
        NaNGrFfq1GWxQIwiUFFhFzdHBHrCsF5KGHYzf5YaCT5ex+hTW/+0224OGYRFMOnaMIPxOlMfLR6ZG
        Unmk7oAJXp/0Ym2X7utM9eZJNNyMvyIMFfBAGNiKJDux8rPlYtr9LfUr0mHS449xC99qClyxNGHGo
        LNOcC8kuN7GXmNadYtyNfrrgU2Y2cBk4FwN8AJRY87d6qm+EpULHlLBTJBrTdQ6mdgoDWJHIYH9rt
        99iB6hetnXt3BXx1McJ5P482mPTkZxdViEx+58bZABjGM8GagzEUldaUd+Fs/2WC3dyh1sMq5g2sp
        3rSQByzA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mpTM5-0003in-Kh; Tue, 23 Nov 2021 10:48:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2E29D300230;
        Tue, 23 Nov 2021 11:48:51 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 15B992C03BF66; Tue, 23 Nov 2021 11:48:51 +0100 (CET)
Date:   Tue, 23 Nov 2021 11:48:51 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     joao@overdrivepizza.com, nstange@suse.de, pmladek@suse.cz,
        jpoimboe@redhat.com, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        alexei.starovoitov@gmail.com
Subject: Re: CET/IBT support and live-patches
Message-ID: <YZzHE+Cze9AX6HCZ@hirez.programming.kicks-ass.net>
References: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com>
 <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Nov 23, 2021 at 10:58:57AM +0100, Miroslav Benes wrote:
> [ adding more CCs ]
> 
> On Mon, 22 Nov 2021, joao@overdrivepizza.com wrote:
> 
> > Hi Miroslav, Petr and Nicolai,
> > 
> > Long time no talk, I hope you are all still doing great :)
> 
> Everything great here :)
> 
> > So, we have been cooking a few patches for enabling Intel CET/IBT support in
> > the kernel. The way IBT works is -- whenever you have an indirect branch, the
> > control-flow must land in an endbr instruction. The idea is to constrain
> > control-flow in a way to make it harder for attackers to achieve meaningful
> > computation through pointer/memory corruption (as in, an attacker that can
> > corrupt a function pointer by exploiting a memory corruption bug won't be able
> > to execute whatever piece of code, being restricted to jump into endbr
> > instructions). To make the allowed control-flow graph more restrict, we are
> > looking into how to minimize the number of endbrs in the final kernel binary
> > -- meaning that if a function is never called indirectly, it shouldn't have an
> > endbr instruction, thus increasing the security guarantees of the hardware
> > feature.
> > 
> > Some ref about what is going on --
> > https://lore.kernel.org/lkml/20211122170805.149482391@infradead.org/T/
> 
> Yes, I noticed something was happening again. There was a thread on this 
> in February https://lore.kernel.org/all/20210207104022.GA32127@zn.tnic/ 
> and some concerns were raised back then around fentry and int3 patching if 
> I remember correctly. Is this still an issue?

The problem was bpf, and probably still is. I've not come around to
looking at it. Asusming fentry is at +0 is silly (although I would like
to see that restored for other reasons), but bpf will also need to emit
ENDBR at least at the start of every JIT'ed program, because entry into
them is through an indirect branch.

If nobody beats me to it, I'll get around to it eventually.
