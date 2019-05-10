Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 803BD19900
	for <lists+live-patching@lfdr.de>; Fri, 10 May 2019 09:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfEJHaU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 May 2019 03:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbfEJHaT (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 May 2019 03:30:19 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8F332175B;
        Fri, 10 May 2019 07:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557473419;
        bh=BWrULVzHUxmrIZ/1PBVnKb7g/rLEN890zSUCxeUSOSE=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=uC9XIXL5NOnZiIp1vI/7XQ5e8RSwZ4IT5AyZqoCVLEKI36bA3aJ7ebMhe8K9UrwZK
         NB1cOHJMRucygvFiEebZKXgQwJpXbnf6xXOwc7cXZlfBuV/wIwek5990NI2/ITYz+C
         1hVHTxl4GyWwqagtyopplsoOJ6pfWsNyveCFmpN8=
Date:   Fri, 10 May 2019 09:30:14 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org,
        the arch/x86 maintainers <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC][PATCH] ftrace/x86: Remove mcount support
In-Reply-To: <20190509222858.3ef96113@gandalf.local.home>
Message-ID: <nycvar.YFH.7.76.1905100929290.17054@cbobk.fhfr.pm>
References: <20190509154902.34ea14f8@gandalf.local.home> <CAHk-=wgZGWpXdscUHyuoRqkJ8XD5Wh2Q-320KGFBhGoBJGzAWQ@mail.gmail.com> <20190509222858.3ef96113@gandalf.local.home>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 9 May 2019, Steven Rostedt wrote:

> As this patch is simply a "remove mcount" patch, I'd like to have the 
> removal of klp_check_compiler_support() be a separate patch.
> 
> Jiri or Josh, care to send a patch on top of this one?

Sure thing, I'll do that once you send v2 fixing x86_32 of your patch.

Thanks,

-- 
Jiri Kosina
SUSE Labs

