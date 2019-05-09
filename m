Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5CE1932A
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 22:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfEIUDv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 16:03:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbfEIUDv (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 16:03:51 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F993217D6;
        Thu,  9 May 2019 20:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557432230;
        bh=1h5pf+PgI1ze0zG0dxJiwZCr50xCtqOEV+0QRD35hGI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=TsT1FwnE9XKaY2QufDYPScUIPG9kRmBDhVvW48AbqXjPv/RbUF8s3a+Lz9rTz2MtQ
         GyN4RJ0BrbF7QK5F0t3//5Cqe5wj6zIuUNASWQQ7VAVOSROC/aXOvEybXfm3xJBtPs
         IG1p8kw8+Wu1Ke48tb/85Z4gVKMGouUlcwbxFtjI=
Date:   Thu, 9 May 2019 22:03:46 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC][PATCH] ftrace/x86: Remove mcount support
In-Reply-To: <20190509154902.34ea14f8@gandalf.local.home>
Message-ID: <nycvar.YFH.7.76.1905092202460.17054@cbobk.fhfr.pm>
References: <20190509154902.34ea14f8@gandalf.local.home>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 9 May 2019, Steven Rostedt wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> There's two methods of enabling function tracing in Linux on x86. One is
> with just "gcc -pg" and the other is "gcc -pg -mfentry". The former will use
> calls to a special function "mcount" after the frame is set up in all C
> functions. The latter will add calls to a special function called "fentry"
> as the very first instruction of all C functions.
> 
> At compile time, there is a check to see if gcc supports, -mfentry, and if
> it does, it will use that, because it is more versatile and less error prone
> for function tracing.
> 
> Starting with v4.19, the minimum gcc supported to build the Linux kernel,
> was raised to version 4.6. That also happens to be the first gcc version to
> support -mfentry. Since on x86, using gcc versions from 4.6 and beyond will
> unconditionally enable the -mfentry, it will no longer use mcount as the
> method for inserting calls into the C functions of the kernel. This means
> that there is no point in continuing to maintain mcount in x86.
> 
> Remove support for using mcount. This makes the code less complex, and will
> also allow it to be simplified in the future.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Thanks; the fact that mcount happens only after the prologue has already 
happened makes it unusuable anyway for anything nontrivial.

	Acked-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
SUSE Labs

