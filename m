Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2703D58FCC
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2019 03:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfF1BiA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 27 Jun 2019 21:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbfF1BiA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 27 Jun 2019 21:38:00 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01173205F4;
        Fri, 28 Jun 2019 01:37:57 +0000 (UTC)
Date:   Thu, 27 Jun 2019 21:37:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ftrace/x86: Add a comment to why we take text_mutex in
 ftrace_arch_code_modify_prepare()
Message-ID: <20190627213756.25e7b914@gandalf.local.home>
In-Reply-To: <20190628012109.p7a2whpsnad5vjz7@treble>
References: <20190627211819.5a591f52@gandalf.local.home>
        <20190628012109.p7a2whpsnad5vjz7@treble>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 27 Jun 2019 20:21:09 -0500
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> On Thu, Jun 27, 2019 at 09:18:19PM -0400, Steven Rostedt wrote:
> > 
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > 
> > Taking the text_mutex in ftrace_arch_code_modify_prepare() is to fix a
> > race against module loading and live kernel patching that might try to
> > change the text permissions while ftrace has it as read/write. This
> > really needs to be documented in the code. Add a comment that does such.
> > 
> > Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

 
> 
> Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
> 

Thanks!

-- Steve
