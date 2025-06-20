Return-Path: <live-patching+bounces-1523-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA5AAE1B0D
	for <lists+live-patching@lfdr.de>; Fri, 20 Jun 2025 14:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9714C4A788F
	for <lists+live-patching@lfdr.de>; Fri, 20 Jun 2025 12:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E192B28469A;
	Fri, 20 Jun 2025 12:36:03 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07AF221FC0;
	Fri, 20 Jun 2025 12:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750422963; cv=none; b=SOI5+PGcUo7trdrpXRs72tyBJv8cTvyX8QeCAiH7ok+/oc+GA38gJhYS3Jk0huUHKqMH0cH+yY2Wx1P5Ky7hSSmwgQssYmAnPIiY+k7W/ycTCkC2h8e9TwulaTIWlmw4buBiCR5wB8tFbl2K6lasS1n59ysv9jtOvQAgqn+qrjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750422963; c=relaxed/simple;
	bh=hTvWgvCXEOqv1aFSHoNRAo6XY1+qI6tBcv1aKl6zzbY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tDdsjVO2ddsw3FPbW1hy8Wr7TzYUzMqYuX7vRFfGwNNTJEIqiBflwPSIvJOqrGnTT9vwGfw/dGV6+uYFPxftU1sDyM7ZThulLSAjgkGj06FH873a16Yr+xB3oz/ax9xn7WkAVXOqQ0wJYLrsQQyyIyqDQaTNZHMwEACA1CvrETE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C142C4CEEE;
	Fri, 20 Jun 2025 12:36:00 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>,
	andrea.porta@suse.com,
	jpoimboe@kernel.org,
	leitao@debian.org,
	linux-toolchains@vger.kernel.org,
	live-patching@vger.kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	song@kernel.org
Subject: Re: [PATCH 0/2] arm64: stacktrace: Enable reliable stacktrace
Date: Fri, 20 Jun 2025 13:35:58 +0100
Message-Id: <175042293850.3925078.16138215907121902894.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250521111000.2237470-1-mark.rutland@arm.com>
References: <20250521111000.2237470-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 21 May 2025 12:09:58 +0100, Mark Rutland wrote:
> These patches enable (basic) reliable stacktracing for arm64,
> terminating at exception boundaries as we do not yet have data necessary
> to determine whether or not the LR is live.
> 
> The key changes are in patch 2, which is derived from Song Liu's earlier
> patch:
> 
> [...]

Applied to arm64 (for-next/livepatch), thanks!

[1/2] arm64: stacktrace: Check kretprobe_find_ret_addr() return value
      https://git.kernel.org/arm64/c/beecfd6a88a6
[2/2] arm64: stacktrace: Implement arch_stack_walk_reliable()
      https://git.kernel.org/arm64/c/805f13e403cd

-- 
Catalin


