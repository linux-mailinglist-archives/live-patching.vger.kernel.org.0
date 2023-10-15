Return-Path: <live-patching+bounces-9-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D347C988B
	for <lists+live-patching@lfdr.de>; Sun, 15 Oct 2023 12:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6875B20C03
	for <lists+live-patching@lfdr.de>; Sun, 15 Oct 2023 10:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A6072119;
	Sun, 15 Oct 2023 10:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="iUrRrh8O"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5834A23AF
	for <live-patching@vger.kernel.org>; Sun, 15 Oct 2023 10:03:29 +0000 (UTC)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67CDDD
	for <live-patching@vger.kernel.org>; Sun, 15 Oct 2023 03:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1697364202;
	bh=Mke0dnFejaTWMpzHUAbVKCThE3iF96U/Yymw0Fb3yp0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=iUrRrh8OZ8qN1e3YI4DJZERCcjPE9UYJ8jGbqoUOGEXF7jbhutAV5IuP2akhFCyMf
	 4+kYNuWprpdsy6SL6/9eQxgeR0EEoqZmmRyVonelnZthfwFErms68ZNQnKtJukAv7z
	 u5wrC1CoqNT1lPvWw2yv2VShnDIe/SK/PNHT6mhauc/4D8EeLEVYXdYy/aQokxXAzX
	 pw2IJ0fq5H9UjGeAtKi4Snnm3XvehrmwerJEZ2YergaxA//s0poMuID2w7F5Y/hKnC
	 do3QW9cUp7p6o37iS1tKHWAXsBZYUERuZWyQVdRyazl9X/c+I64gMxcyXj+lMOewMF
	 uAWjqwK0B+u+A==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4S7bRG1qdJz4wwG;
	Sun, 15 Oct 2023 21:03:22 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: linuxppc-dev@lists.ozlabs.org, Michael Ellerman <mpe@ellerman.id.au>
Cc: npiggin@gmail.com, joe.lawrence@redhat.com, pmladek@suse.com, live-patching@vger.kernel.org
In-Reply-To: <20230921232441.1181843-1-mpe@ellerman.id.au>
References: <20230921232441.1181843-1-mpe@ellerman.id.au>
Subject: Re: [PATCH] powerpc/stacktrace: Fix arch_stack_walk_reliable()
Message-Id: <169736402372.957740.3532327123925195902.b4-ty@ellerman.id.au>
Date: Sun, 15 Oct 2023 21:00:23 +1100
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 22 Sep 2023 09:24:41 +1000, Michael Ellerman wrote:
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
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/stacktrace: Fix arch_stack_walk_reliable()
      https://git.kernel.org/powerpc/c/c5cc3ca707bc916a3f326364751a41f25040aef3

cheers

