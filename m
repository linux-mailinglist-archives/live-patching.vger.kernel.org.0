Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9553E2B41
	for <lists+live-patching@lfdr.de>; Fri,  6 Aug 2021 15:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343976AbhHFNXJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Aug 2021 09:23:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231889AbhHFNXI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Aug 2021 09:23:08 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0176861078;
        Fri,  6 Aug 2021 13:22:51 +0000 (UTC)
Date:   Fri, 6 Aug 2021 09:22:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     live-patching@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: Reference to non-existing DYNAMIC_FTRACE_WITH_ARGS
Message-ID: <20210806092250.1bb21ac6@oasis.local.home>
In-Reply-To: <CAKXUXMwT2zS9fgyQHKUUiqo8ynZBdx2UEUu1WnV_q0OCmknqhw@mail.gmail.com>
References: <CAKXUXMwT2zS9fgyQHKUUiqo8ynZBdx2UEUu1WnV_q0OCmknqhw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 6 Aug 2021 12:18:36 +0200
Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:

> Hi Steven,

Hi Lukas, thanks for the report.

> Did you intend to depend on the existing "HAVE_DYNAMIC_FTRACE_WITH_ARGS" here?
> 
> Or did you intend to add a new config DYNAMIC_FTRACE_WITH_ARGS
> analogously to DYNAMIC_FTRACE_WITH_REGS as defined in
> ./kernel/trace/Kconfig (see below)?
> 
> config DYNAMIC_FTRACE_WITH_REGS
>         def_bool y
>         depends on DYNAMIC_FTRACE
>         depends on HAVE_DYNAMIC_FTRACE_WITH_REGS
> 
> I am happy to provide a patch, once I understand what was intended here.
> 

Yeah, that looks to be the missing part. The
HAVE_DYNAMIC_FTRACE_WITH_ARGS is just showing support, but knowing it
is enabled would require DYNAMIC_FTRACE being set (which is user
enabled).

Feel free to send a patch, and mark it for stable.

-- Steve
