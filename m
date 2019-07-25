Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9F874F8C
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2019 15:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388004AbfGYNd5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Jul 2019 09:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388009AbfGYNd5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Jul 2019 09:33:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 246F12190F;
        Thu, 25 Jul 2019 13:33:55 +0000 (UTC)
Date:   Thu, 25 Jul 2019 09:33:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] kprobes: Allow kprobes coexist with livepatch
Message-ID: <20190725093353.6e4d561f@gandalf.local.home>
In-Reply-To: <156403587671.30117.5233558741694155985.stgit@devnote2>
References: <156403587671.30117.5233558741694155985.stgit@devnote2>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 25 Jul 2019 15:24:37 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Allow kprobes which do not modify regs->ip, coexist with livepatch
> by dropping FTRACE_OPS_FL_IPMODIFY from ftrace_ops.
> 
> User who wants to modify regs->ip (e.g. function fault injection)
> must set a dummy post_handler to its kprobes when registering.
> However, if such regs->ip modifying kprobes is set on a function,
> that function can not be livepatched.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>


Looks good! I applied it.

Thanks Masami!

-- Steve
