Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2AA76EB1
	for <lists+live-patching@lfdr.de>; Fri, 26 Jul 2019 18:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfGZQOw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 26 Jul 2019 12:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfGZQOw (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 26 Jul 2019 12:14:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82877218DA;
        Fri, 26 Jul 2019 16:14:50 +0000 (UTC)
Date:   Fri, 26 Jul 2019 12:14:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] kprobes: Allow kprobes coexist with livepatch
Message-ID: <20190726121449.22f0989e@gandalf.local.home>
In-Reply-To: <20190726020752.GA6388@redhat.com>
References: <156403587671.30117.5233558741694155985.stgit@devnote2>
        <20190726020752.GA6388@redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 25 Jul 2019 22:07:52 -0400
Joe Lawrence <joe.lawrence@redhat.com> wrote:

> These results reflect my underestanding of FTRACE_OPS_FL_IPMODIFY in
> light of your changes, so feel free to add my:
> 
> Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

Is this an urgent patch (needs to go in now and not wait for the next
merge window) and if so, should it be marked for stable?

-- Steve
