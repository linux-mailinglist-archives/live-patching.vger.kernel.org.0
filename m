Return-Path: <live-patching+bounces-7-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A54D7AABD0
	for <lists+live-patching@lfdr.de>; Fri, 22 Sep 2023 10:09:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sy.mirrors.kernel.org (Postfix) with ESMTP id B0E34B208A8
	for <lists+live-patching@lfdr.de>; Fri, 22 Sep 2023 08:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4F81DA33;
	Fri, 22 Sep 2023 08:09:13 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20D814F81
	for <live-patching@vger.kernel.org>; Fri, 22 Sep 2023 08:09:11 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F8210C4
	for <live-patching@vger.kernel.org>; Fri, 22 Sep 2023 01:09:10 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 26E1C1F38A;
	Fri, 22 Sep 2023 08:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1695370149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0gLx5up2W0A7onZ8plsSQicHSESF10QpvNgWlLnvzwE=;
	b=tPBubHruDJanyHQ9yo0YvG8PNFgbYsJmVz/bV7ZQTXDr0Nsdu+vzjpGVXWn67ioWfCV4y7
	3NBUSrZRwrtPDV+mFyYO5y4B2c6WITyt2U7QlIdzqLPQzYpqqAdtpASIw0xvqusBvDmfZf
	fiTjQxxX+7YloY6n2zlTZ2YN1OM66dg=
Received: from suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id E652D2C142;
	Fri, 22 Sep 2023 08:09:08 +0000 (UTC)
Date: Fri, 22 Sep 2023 10:09:07 +0200
From: Petr Mladek <pmladek@suse.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, npiggin@gmail.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH] powerpc/stacktrace: Fix arch_stack_walk_reliable()
Message-ID: <ZQ1LoyYaM3wLg5m_@alley>
References: <20230921232441.1181843-1-mpe@ellerman.id.au>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921232441.1181843-1-mpe@ellerman.id.au>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri 2023-09-22 09:24:41, Michael Ellerman wrote:
> The changes to copy_thread() made in commit eed7c420aac7 ("powerpc:
> copy_thread differentiate kthreads and user mode threads") inadvertently
> broke arch_stack_walk_reliable() because it has knowledge of the stack
> layout.
> 
> Fix it by changing the condition to match the new logic in
> copy_thread(). The changes make the comments about the stack layout
> incorrect, rather than rephrasing them just refer the reader to
> copy_thread().
> 
> Also the comment about the stack backchain is no longer true, since
> commit edbd0387f324 ("powerpc: copy_thread add a back chain to the
> switch stack frame"), so remove that as well.
> 
> Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Fixes: eed7c420aac7 ("powerpc: copy_thread differentiate kthreads and user mode threads")

The change makes sense to me. Well, I could not test it easily.
Anyway, feel free to use:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

