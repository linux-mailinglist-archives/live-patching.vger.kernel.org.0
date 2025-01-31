Return-Path: <live-patching+bounces-1099-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B372DA2400D
	for <lists+live-patching@lfdr.de>; Fri, 31 Jan 2025 17:08:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35742167EBB
	for <lists+live-patching@lfdr.de>; Fri, 31 Jan 2025 16:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1401E00B6;
	Fri, 31 Jan 2025 16:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="G2VTov39"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2C720318;
	Fri, 31 Jan 2025 16:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738339733; cv=none; b=gUBKZp4o71L5Q+7UfQ+h2hL19F6K4b2p2GOWGQro9v5OuFv9hwH9dM37kFGb8Or40xhOFJ8GqkTR7cKOaFdN+5bg8XK+pnLepG/x3Qg4d3R2QTu0nEYoMU+gw1gGoOoFL6EAQNm4hXnMk5Sf8oNByix+6GiZtJqE+37SfJs1cTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738339733; c=relaxed/simple;
	bh=IQL7s3lbKnKcTKB9pEi0zzCn3XcNQtutTRmxglLPsAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bmPyC0V/+8DLpizJ94th0pLyUidZGpdaW3imgnOXi3SLZso+BxUr3MaeCJ1lJiIXV4VdLzq+H0JLFpfWPwxowp4yaI+oiCuKnoAWPs88qiuTNO/9yP/6SOgs3uUwbbLFa/N+16taQVbjB4/RaRcqUgu4GQr8HxcXx2WadomDqkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=G2VTov39; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.79.217.67] (unknown [4.194.122.170])
	by linux.microsoft.com (Postfix) with ESMTPSA id D324D210C321;
	Fri, 31 Jan 2025 08:08:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D324D210C321
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738339732;
	bh=c3gnIl846SAu9tfnQfOzMciM9PIb15NdkYL4iUYcpms=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G2VTov39rrmYBiWMyE9yWrSILfGhZxzr06F8JH2GqHFzuspx00BCSmiWBbsDjUsyp
	 oXVBU8KH8BrukMrKGOrPvvDtGBseuczir06TjCxMZyTdSIbN5Ei8FguLKbk8PKHD5J
	 NC1IKKeAL6q/duree0ur7zHHvgb38S+jlVktLiVs=
Message-ID: <ceabc7b5-a9b8-4f3b-9a73-5cc2af4e9af9@linux.microsoft.com>
Date: Fri, 31 Jan 2025 21:38:46 +0530
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

Will this work for ftrace'd (kprobe'd) function as well?


