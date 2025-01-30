Return-Path: <live-patching+bounces-1086-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65B10A22AF2
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 10:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D01F016334E
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 09:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B84D1B85C9;
	Thu, 30 Jan 2025 09:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="WTmKbxGt"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25FE183098;
	Thu, 30 Jan 2025 09:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230926; cv=none; b=EkwIKIgcG5mg0dkr0WjmC6iCDMBMy+QEtALwuOJQCFoj/7a8yuF7JgjFSz01FTuKbkN2pLM8Ei27R8G2B21zKMkfVjClSI0QZ+vA5ajA+WyZPLJB1VUjI3T49yDlczhAOsXnSGhYQ4xsrdADBY0+aCbtU78W2eXQEW4luAkOrPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230926; c=relaxed/simple;
	bh=uVXnP0MHRygfKEsxbCJvrGhQ3Skv97e1d4WGaFuVxdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=slVS/0W1sA5vS8IhfW6hQv9K0VQ8Tpq1Sss17z639uIKj3Mf8rHLrcMGCgDmBB7ovyv7ca5KzoI0Qjo9deJE4L5gHpigkono7gRjYoUuR/LcD0nU00bOKZLEvyypinS7x19aEjQN+2pqniItBybrOdIgjOkC0s6gQa+Z81n7OTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=WTmKbxGt; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.156.205.88] (unknown [167.220.238.88])
	by linux.microsoft.com (Postfix) with ESMTPSA id 250B62109CF3;
	Thu, 30 Jan 2025 01:55:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 250B62109CF3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738230924;
	bh=8CWQ+Ltpzm0FOglk01f1SBbns7Cqp8rGnr3E8DmO8mI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WTmKbxGtIfYc2mv3Cak/Vwplr5T5/GHoFm736jp1fVaNrpl8fmdlj0kmdF5iBAqRD
	 LNVVWiE6Hsd5uZhgE9dVXwVyq3Tzatl49e24vAKqpYDxCHKaZhJGJO6xhOYyI9SWXR
	 FPmMX70ExaE325FCoXSRlMRurmu2vSZB/gXdSpFQ=
Message-ID: <b7ca6841-a103-48ea-8353-4e8c089e9176@linux.microsoft.com>
Date: Thu, 30 Jan 2025 15:25:20 +0530
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] arm64: Enable livepatch for ARM64
To: Weinan Liu <wnliu@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
 Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
 linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, joe.lawrence@redhat.com,
 linux-arm-kernel@lists.infradead.org
References: <20250127213310.2496133-1-wnliu@google.com>
 <20250127213310.2496133-9-wnliu@google.com>
Content-Language: en-US
From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
In-Reply-To: <20250127213310.2496133-9-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 28-01-2025 03:03, Weinan Liu wrote:
> Since SFrame is considered as reliable stacktrace, enable livepatch in
> arch/arm64/Kconfig
>
> Signed-off-by: Weinan Liu <wnliu@google.com>
> ---
>   arch/arm64/Kconfig | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 100570a048c5..c292bc73b65c 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -271,6 +271,8 @@ config ARM64
>   	select HAVE_SOFTIRQ_ON_OWN_STACK
>   	select USER_STACKTRACE_SUPPORT
>   	select VDSO_GETRANDOM
> +	select HAVE_RELIABLE_STACKTRACE if SFRAME_UNWINDER
> +	select HAVE_LIVEPATCH		if HAVE_DYNAMIC_FTRACE_WITH_ARGS && HAVE_RELIABLE_STACKTRACE
>   	help
>   	  ARM 64-bit (AArch64) Linux support.
>   
> @@ -2498,3 +2500,4 @@ source "drivers/acpi/Kconfig"
>   
>   source "arch/arm64/kvm/Kconfig"
>   
> +source "kernel/livepatch/Kconfig"

Looks good to me.
Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>.


