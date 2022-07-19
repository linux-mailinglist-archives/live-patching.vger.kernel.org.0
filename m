Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DDD57AA70
	for <lists+live-patching@lfdr.de>; Wed, 20 Jul 2022 01:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238087AbiGSX1V (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Jul 2022 19:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238173AbiGSX1U (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Jul 2022 19:27:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368B261D9B;
        Tue, 19 Jul 2022 16:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C653861337;
        Tue, 19 Jul 2022 23:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365DAC341C6;
        Tue, 19 Jul 2022 23:27:17 +0000 (UTC)
Date:   Tue, 19 Jul 2022 19:27:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops
 on the same function
Message-ID: <20220719192715.2b93ef70@gandalf.local.home>
In-Reply-To: <D9D41674-8EFF-4A30-97C5-F2C1B31C1F22@fb.com>
References: <20220718055449.3960512-1-song@kernel.org>
        <20220718055449.3960512-3-song@kernel.org>
        <20220719142856.7d87ea6d@gandalf.local.home>
        <D9D41674-8EFF-4A30-97C5-F2C1B31C1F22@fb.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 19 Jul 2022 23:24:35 +0000
Song Liu <songliubraving@fb.com> wrote:

> Actually, we cannot blindly lock direct_mutex here, as 
> register_ftrace_direct() already locks it before calling 
> register_ftrace_function(). We still need the if (IPMODIFY)
> check. 

Let's not play games with this then.

Create a register_ftrace_function_nolock()

and use that for register_ftrace_direct().

Otherwise it's going to be a nightmare to keep track of.

-- Steve
