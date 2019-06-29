Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34E75AD7B
	for <lists+live-patching@lfdr.de>; Sat, 29 Jun 2019 23:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfF2VTf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 29 Jun 2019 17:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbfF2VTf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sat, 29 Jun 2019 17:19:35 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A19D216FD;
        Sat, 29 Jun 2019 21:19:33 +0000 (UTC)
Date:   Sat, 29 Jun 2019 17:19:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ftrace: Remove possible deadlock between
 register_kprobe() and ftrace_run_update_code()
Message-ID: <20190629171931.770f05a5@gandalf.local.home>
In-Reply-To: <nycvar.YFH.7.76.1906292256100.27227@cbobk.fhfr.pm>
References: <20190627081334.12793-1-pmladek@suse.com>
        <20190627224729.tshtq4bhzhneq24w@treble>
        <20190627190457.703a486e@gandalf.local.home>
        <alpine.DEB.2.21.1906280106360.32342@nanos.tec.linutronix.de>
        <20190627231952.nqkbtcculvo2ddif@treble>
        <nycvar.YFH.7.76.1906281932360.27227@cbobk.fhfr.pm>
        <20190628133702.16a54ccf@gandalf.local.home>
        <nycvar.YFH.7.76.1906292256100.27227@cbobk.fhfr.pm>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, 29 Jun 2019 22:56:47 +0200 (CEST)
Jiri Kosina <jikos@kernel.org> wrote:

> > Care to send a patch? :-)  
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] ftrace/x86: anotate text_mutex split between ftrace_arch_code_modify_post_process() and ftrace_arch_code_modify_prepare()

Care to send a proper patch ;-)

As in, a separate email. Makes it much easier to apply directly with
my scripts.

-- Steve
