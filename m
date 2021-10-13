Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B3042BA21
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 10:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhJMI1p (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Oct 2021 04:27:45 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58984 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhJMI1p (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Oct 2021 04:27:45 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id EAFE122293;
        Wed, 13 Oct 2021 08:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634113540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gtfMhdTCLZEryLgjqIY9aS8OXYQtmP7j21hE/U/0byU=;
        b=XuZS1UsK+pfyAdOjBepbUpW8kD9Wf+FpL5NRUCIiFXRNt+KflFTVQ2adE8t1vhhNnd+ZFX
        y7b55Uu04L7SStRKxz1Tl1kX7YvnJ5hKwm6Tg8+Z5msjQfyaaHzbBuTIG+AmINlEmd+ObI
        CDgbPtcvrmua8hGgAe8Td9n54vleRBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634113540;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gtfMhdTCLZEryLgjqIY9aS8OXYQtmP7j21hE/U/0byU=;
        b=f5Y5fFwlmKK9upr3244TYcrXdUE5DgxW2RHInIuAqU0gultFbVn42x1Sg/1NorKEDGSOVR
        3Pp6eeu/JPTFI6Bw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 74849A3B84;
        Wed, 13 Oct 2021 08:25:39 +0000 (UTC)
Date:   Wed, 13 Oct 2021 10:25:39 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     =?ISO-2022-JP?Q?=1B$B2&lV=1B=28J?= <yun.wang@linux.alibaba.com>
cc:     Guo Ren <guoren@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
Subject: Re: [RESEND PATCH v2 1/2] ftrace: disable preemption between
 ftrace_test_recursion_trylock/unlock()
In-Reply-To: <d5fbd49a-55c5-a9f5-6600-707c8d749312@linux.alibaba.com>
Message-ID: <alpine.LSU.2.21.2110131022590.5647@pobox.suse.cz>
References: <b1d7fe43-ce84-0ed7-32f7-ea1d12d0b716@linux.alibaba.com> <75ee86ac-02f2-d687-ab1e-9c8c33032495@linux.alibaba.com> <alpine.LSU.2.21.2110130948120.5647@pobox.suse.cz> <d5fbd49a-55c5-a9f5-6600-707c8d749312@linux.alibaba.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> > Side note... the comment will eventually conflict with peterz's 
> > https://lore.kernel.org/all/20210929152429.125997206@infradead.org/.
> 
> Steven, would you like to share your opinion on this patch?
> 
> If klp_synchronize_transition() will be removed anyway, the comments
> will be meaningless and we can just drop it :-P

The comment will still be needed in some form. We will handle it depending 
on what gets merged first. peterz's patches are not ready yet.

Miroslav
