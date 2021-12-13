Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A494732F7
	for <lists+live-patching@lfdr.de>; Mon, 13 Dec 2021 18:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbhLMRdo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Dec 2021 12:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235736AbhLMRdo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Dec 2021 12:33:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBDBC061574;
        Mon, 13 Dec 2021 09:33:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6A93B811E7;
        Mon, 13 Dec 2021 17:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392BBC34600;
        Mon, 13 Dec 2021 17:33:40 +0000 (UTC)
Date:   Mon, 13 Dec 2021 12:33:38 -0500
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
Message-ID: <20211213123338.65eda5a0@gandalf.local.home>
In-Reply-To: <5511f43c-192a-622b-7c72-52e07f0032c2@csgroup.eu>
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
        <20211028093547.48c69dfe@gandalf.local.home>
        <6209682d-0caa-b779-8763-376a984d8ed8@csgroup.eu>
        <20211213121536.25e5488d@gandalf.local.home>
        <5511f43c-192a-622b-7c72-52e07f0032c2@csgroup.eu>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 13 Dec 2021 17:30:48 +0000
Christophe Leroy <christophe.leroy@csgroup.eu> wrote:

> Thanks, I will try that.
> 
> I can't find ftrace_graph_func() in s390. Does it mean that s390 doesn't 
> have a working function tracer anymore ?
> 
> I see your commit 0c0593b45c9b4 ("x86/ftrace: Make function graph use 
> ftrace directly") is dated 8 Oct 2021 while 5740a7c71ab6 ("s390/ftrace: 
> add HAVE_DYNAMIC_FTRACE_WITH_ARGS support") is 4 Oct 2021.

Hmm, maybe not. I can't test it.

This needs to be fixed if that's the case.

Thanks for bringing it up!

-- Steve
