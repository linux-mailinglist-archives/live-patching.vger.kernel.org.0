Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F2357A5E2
	for <lists+live-patching@lfdr.de>; Tue, 19 Jul 2022 19:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbiGSR5i (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Jul 2022 13:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbiGSR5i (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Jul 2022 13:57:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B9749B50;
        Tue, 19 Jul 2022 10:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6815961708;
        Tue, 19 Jul 2022 17:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB22C341C6;
        Tue, 19 Jul 2022 17:57:34 +0000 (UTC)
Date:   Tue, 19 Jul 2022 13:57:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <song@kernel.org>
Cc:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 1/4] ftrace: add
 modify_ftrace_direct_multi_nolock
Message-ID: <20220719135733.3fea9f14@gandalf.local.home>
In-Reply-To: <20220718055449.3960512-2-song@kernel.org>
References: <20220718055449.3960512-1-song@kernel.org>
        <20220718055449.3960512-2-song@kernel.org>
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

On Sun, 17 Jul 2022 22:54:46 -0700
Song Liu <song@kernel.org> wrote:

> Subject: [PATCH v4 bpf-next 1/4] ftrace: add modify_ftrace_direct_multi_nolock

FYI, ftrace and tracing style is to capitalize the first word in the
subject.

    ftrace: Add modify_ftrace_direct_multi_nolock

Please fix this in the next version.

-- Steve


> Date: Sun, 17 Jul 2022 22:54:46 -0700
> Message-ID: <20220718055449.3960512-2-song@kernel.org>
> 
> This is similar to modify_ftrace_direct_multi, but does not acquire
> direct_mutex. This is useful when direct_mutex is already locked by the
> user.
> 
> Signed-off-by: Song Liu <song@kernel.org>
