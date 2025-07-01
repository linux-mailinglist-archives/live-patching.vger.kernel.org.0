Return-Path: <live-patching+bounces-1613-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49790AEFC52
	for <lists+live-patching@lfdr.de>; Tue,  1 Jul 2025 16:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 787683B5348
	for <lists+live-patching@lfdr.de>; Tue,  1 Jul 2025 14:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 542E1275110;
	Tue,  1 Jul 2025 14:28:40 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D771D79A5;
	Tue,  1 Jul 2025 14:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751380120; cv=none; b=gg2fGzQ553JqDpQshkihozH8TxvuG6BYJ+7U1oD6mLHQ1RAdefZh//PlK5zt/NQvlqi2pVHfLtkeMHMyZPyM1821M9tpOu/WeMv05qwDvLfS9IuLvaZVtfgVq+Nj4qNP+kVbsIfj4VHYMSXw93bOhe9Xor+ycI/yNRD5RTSTrFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751380120; c=relaxed/simple;
	bh=c8FcvF0sDojKq6CEwx9YZeroWQkF9ybiQlGtLOpU4aQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4YyV0gr0v20GmsPTrGqHToE96LnqWqQv/Y3C1zOmiScBG2VUGwHEFcoIcmFrYBpjWF7TMl2zEfAR0O7f4ehuLqmZLxTLwDVEApvqfgIN8+ema6Z0RQ+UTDbcsFaZUFTUv6z4ywSh4tcqoIJokeT3ikD+YwFWIpzkRMhRmtw8Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D993C4CEEB;
	Tue,  1 Jul 2025 14:28:36 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Song Liu <song@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	dylanbhatch@google.com,
	fj6611ie@aa.jp.fujitsu.com,
	mark.rutland@arm.com,
	kernel-team@meta.com,
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Torsten Duwe <duwe@suse.de>,
	Breno Leitao <leitao@debian.org>,
	Andrea della Porta <andrea.porta@suse.com>
Subject: Re: [PATCH v5] arm64: Implement HAVE_LIVEPATCH
Date: Tue,  1 Jul 2025 15:28:34 +0100
Message-Id: <175138010917.1964100.18246912177187578815.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630174502.842486-1-song@kernel.org>
References: <20250630174502.842486-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 30 Jun 2025 10:45:02 -0700, Song Liu wrote:
> Allocate a task flag used to represent the patch pending state for the
> task. When a livepatch is being loaded or unloaded, the livepatch code
> uses this flag to select the proper version of a being patched kernel
> functions to use for current task.
> 
> In arch/arm64/Kconfig, select HAVE_LIVEPATCH and include proper Kconfig.
> 
> [...]

Applied to arm64 (for-next/livepatch), thanks!

[1/1] arm64: Implement HAVE_LIVEPATCH
      https://git.kernel.org/arm64/c/fd1e0fd71f65

-- 
Catalin


