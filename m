Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6E345AE2B
	for <lists+live-patching@lfdr.de>; Tue, 23 Nov 2021 22:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239630AbhKWVTv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Nov 2021 16:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240413AbhKWVTv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Nov 2021 16:19:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5D1C061574
        for <live-patching@vger.kernel.org>; Tue, 23 Nov 2021 13:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WB1qJYubwLrHilmUmlhG7yW0febtzdjOUKmu9phI5EY=; b=dJLbdg7er8fJaEQU7uyV1a12AB
        MsbZF1YQ3RqNnKZhTzGBSp85lkcZxbHt6rE2yTI8jHkeIdW42+6ibWUL/gAGlZ4G2L+hXSFLAUoyO
        +JjpJkXg/4y6PQp7HpjdjiWsKwfCSeAYJwNwThtnOBtx/FamlFvwhRlgM62UgPQEdXKdfeSGuiWcd
        ZasnSHUGyVk8uGA29Osvl+Azd0wdSvNNfal+bcyot3eG107viDpwrFo22zxBb8N0B+CTyXcN9XFYr
        2my3fyZJ+CheaLOm6h3JcanVnJiEeXygYeKBAbS0lm1xgXkfGklRT6yTMgl0TJDjPD7dcXmn5zjRX
        ub/oDWaA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mpd9Y-00GRhb-S7; Tue, 23 Nov 2021 21:16:37 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 98BB5984951; Tue, 23 Nov 2021 22:16:36 +0100 (CET)
Date:   Tue, 23 Nov 2021 22:16:36 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, joao@overdrivepizza.com,
        nstange@suse.de, pmladek@suse.cz, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
Subject: Re: CET/IBT support and live-patches
Message-ID: <20211123211636.GE721624@worktop.programming.kicks-ass.net>
References: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com>
 <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz>
 <08d4a24d-02c2-6760-96bf-b72f51025808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08d4a24d-02c2-6760-96bf-b72f51025808@redhat.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Nov 23, 2021 at 03:58:51PM -0500, Joe Lawrence wrote:

> Yep, kpatch-build uses its own klp-relocation conversion and not kallsyms.
> 
> I'm not familiar with CET/IBT, but it sounds like if a function pointer
> is not taken at build time (or maybe some other annotation), the
> compiler won't generate the needed endbr landing spot in said function?

Currently it does, but then I'm having objtool scribble it on purpose.

>  And that would be a problem for modules using kallsyms lookup to get to
> said function.

Which is ofcourse the whole purpose of the exercise. If it's not
exported you don't get to call it via a back-door :-) This should kill a
whole heap of dodgy modules quite dead I hope.
