Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBE647443B
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 15:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbhLNOBx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Dec 2021 09:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbhLNOBw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Dec 2021 09:01:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4256BC061574;
        Tue, 14 Dec 2021 06:01:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBA7B614DA;
        Tue, 14 Dec 2021 14:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC22CC34601;
        Tue, 14 Dec 2021 14:01:49 +0000 (UTC)
Date:   Tue, 14 Dec 2021 09:01:48 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v1 0/5] Implement livepatch on PPC32
Message-ID: <20211214090148.264f4660@gandalf.local.home>
In-Reply-To: <aac75717-a3ac-c0b4-3e79-dc6eb9c26d8c@csgroup.eu>
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
        <20211028093547.48c69dfe@gandalf.local.home>
        <6209682d-0caa-b779-8763-376a984d8ed8@csgroup.eu>
        <20211213121536.25e5488d@gandalf.local.home>
        <5511f43c-192a-622b-7c72-52e07f0032c2@csgroup.eu>
        <20211213123338.65eda5a0@gandalf.local.home>
        <fc3099b8-9f12-3e47-08a0-05abc37a0482@csgroup.eu>
        <20211213135410.12642d8f@gandalf.local.home>
        <8df90f94-9939-0178-b92b-6ae6ea81784c@csgroup.eu>
        <20211213144603.47d7c908@gandalf.local.home>
        <76ce2dd7-691e-df73-727c-110713c07cda@csgroup.eu>
        <aac75717-a3ac-c0b4-3e79-dc6eb9c26d8c@csgroup.eu>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 14 Dec 2021 08:35:14 +0100
Christophe Leroy <christophe.leroy@csgroup.eu> wrote:

> > Will continue investigating.
> >   
> 
> trace_selftest_startup_function_graph() calls register_ftrace_direct() 
> which returns -ENOSUPP because powerpc doesn't select 
> CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS.
> 
> Should TEST_DIRECT_TRAMP depend on CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS ?

Yes, that should be:

#if defined(CONFIG_DYNAMIC_FTRACE) && \
    defined(CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS)
#define TEST_DIRECT_TRAMP
noinline __noclone static void trace_direct_tramp(void) { }
#endif


And make it test it with or without the args.

Thanks for finding this.

-- Steve
