Return-Path: <live-patching+bounces-1525-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA06AE9E80
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 15:21:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44A3F1706E8
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 13:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E268C28727B;
	Thu, 26 Jun 2025 13:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwUoYXnT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4DD18C31;
	Thu, 26 Jun 2025 13:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750944080; cv=none; b=OBihrKB1VfdwuPwE4++JlFnas+icley4MN/aKZQOURlHkSmnHSr9RaXzM2pbHMB0Fxn+eHJ2PwIAsjSP+H8Iku7MKb5TOraFGRy41md3Yky/CGD+QP0/D7YPM85cgs/g0bnjF7PXG3tvRsOyqB4xtCVhFUim/K7clkZxJsnC+h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750944080; c=relaxed/simple;
	bh=+aKITQuC7lDOYRYhuqIpftiQh1+f9VhmR+AXFY6JfPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Szpk5t10HXdgTz46ED6LN23FMoh8w/IZqMJM4HrJcYT8FjrPF+Ep9AWeTPqkd8gI0yvDkfskE1LctyYlJX/k1uN6s4Fy+4h2P9jJspFuiVEXipIGGCdWnKl0f4xZ+6QfUfKyDojVGaC48aTU9uPNvdyE/WWd2oXniU8qE2V8ubs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rwUoYXnT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B00C4CEEB;
	Thu, 26 Jun 2025 13:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750944080;
	bh=+aKITQuC7lDOYRYhuqIpftiQh1+f9VhmR+AXFY6JfPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rwUoYXnTKIotVgQ9fi56SWN7rtlgfAiLS+mqGLJZiRRDNaCzdWZo6mgsRauPOfLbY
	 tQhFBp/UMolBQ0KbK7SCibwEZSN8tJa5UKER60o5H6CJyQS6iR31HSYuS8r/LvJfMx
	 zjH6mIzsT4dk8Z1kk2Zah1d/wf0DRshW7HgYoumycor8dRYL3gVzNxeRysHL22UFQx
	 LDr4kl+QvLGWsA0+UKFK4hI3y8H6+A7r3rYWCyh4pps3r/4bTMGCPs6OWKakL5T1Xf
	 6NHEjA3ooA+9cO2ogatALlrLyCUA7b0QU/6q/5govnrM+oGD5bffdWKdQfVouc5ZXL
	 1ykMS2iVyV7RQ==
Date: Thu, 26 Jun 2025 14:21:14 +0100
From: Will Deacon <will@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, jpoimboe@kernel.org,
	jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, catalin.marinas@arm.com,
	dylanbhatch@google.com, fj6611ie@aa.jp.fujitsu.com,
	mark.rutland@arm.com, kernel-team@meta.com,
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Torsten Duwe <duwe@suse.de>, Breno Leitao <leitao@debian.org>,
	Andrea della Porta <andrea.porta@suse.com>
Subject: Re: [PATCH v4] arm64: Implement HAVE_LIVEPATCH
Message-ID: <aF1JShCkslGkch26@willie-the-truck>
References: <20250617173734.651611-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617173734.651611-1-song@kernel.org>

On Tue, Jun 17, 2025 at 10:37:34AM -0700, Song Liu wrote:
> This is largely based on [1] by Suraj Jitindar Singh.

I think it would be useful to preserve at least some parts of the
original commit message here so that folks don't have to pull it out
of the list archives if they want to see more about the rationale.

That aside, the code looks good to me. The sooner we can move over to
the generic entry code, the better.

Acked-by: Will Deacon <will@kernel.org>

Will

