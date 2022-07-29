Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B655855A7
	for <lists+live-patching@lfdr.de>; Fri, 29 Jul 2022 21:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238500AbiG2ToN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Jul 2022 15:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237659AbiG2ToM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Jul 2022 15:44:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303D978DF4;
        Fri, 29 Jul 2022 12:44:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEEB4B82958;
        Fri, 29 Jul 2022 19:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BC0C433D6;
        Fri, 29 Jul 2022 19:44:08 +0000 (UTC)
Date:   Fri, 29 Jul 2022 15:43:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <song@kernel.org>
Cc:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH bpf-next] bpf: fix test_progs -j error with fentry/fexit
 tests
Message-ID: <20220729154357.12cfea5f@rorschach.local.home>
In-Reply-To: <20220729194106.1207472-1-song@kernel.org>
References: <20220729194106.1207472-1-song@kernel.org>
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

On Fri, 29 Jul 2022 12:41:06 -0700
Song Liu <song@kernel.org> wrote:

> Then multiple threads are attaching/detaching fentry/fexit programs to

 "When multiple threads"?

-- Steve

> the same trampoline, we may call register_fentry on the same trampoline
> twice: register_fentry(), unregister_fentry(), then register_fentry again.
> This causes ftrace_set_filter_ip() for the same ip on tr->fops twice,
> which leaves duplicated ip in tr->fops. The extra ip is not cleaned up
> properly on unregister and thus causes failures with further register in
> register_ftrace_direct_multi():
> 
> register_ftrace_direct_multi()
> {
>         ...
>         for (i = 0; i < size; i++) {
>                 hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
>                         if (ftrace_find_rec_direct(entry->ip))
>                                 goto out_unlock;
>                 }
>         }
>         ...
> }
> 
> This can be triggered with parallel fentry/fexit tests with test_progs:
> 
>   ./test_progs -t fentry,fexit -j
> 
> Fix this by resetting tr->fops in ftrace_set_filter_ip(), so that there
> will never be duplicated entries in tr->fops.
> 
