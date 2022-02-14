Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82374B5CE2
	for <lists+live-patching@lfdr.de>; Mon, 14 Feb 2022 22:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiBNVef (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 14 Feb 2022 16:34:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiBNVdo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 14 Feb 2022 16:33:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8AC156941;
        Mon, 14 Feb 2022 13:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CEAE60FEB;
        Mon, 14 Feb 2022 19:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A09C340E9;
        Mon, 14 Feb 2022 19:03:05 +0000 (UTC)
Date:   Mon, 14 Feb 2022 14:03:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Petr Mladek <pmladek@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: [PATCH v2 11/13] powerpc/ftrace: directly call of function
 graph tracer by ftrace caller
Message-ID: <20220214140304.04d1e8a8@gandalf.local.home>
In-Reply-To: <1644859156.qdgqumennn.naveen@linux.ibm.com>
References: <cover.1640017960.git.christophe.leroy@csgroup.eu>
        <04d196585ff81bde06a000bd9c633a33a5b21130.1640017960.git.christophe.leroy@csgroup.eu>
        <1644859156.qdgqumennn.naveen@linux.ibm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 14 Feb 2022 22:54:23 +0530
"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> wrote:

> For x86, commit 0c0593b45c9b4e ("x86/ftrace: Make function graph use 
> ftrace directly") also adds recursion check before the call to 
> function_graph_enter() in prepare_ftrace_return(). Do we need that on
> powerpc as well?

Yes. The function_graph_enter() does not provide any recursion protection,
so if it were to call something that gets function graph traced, it will
crash the machine.

-- Steve
