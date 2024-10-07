Return-Path: <live-patching+bounces-717-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 979E699352F
	for <lists+live-patching@lfdr.de>; Mon,  7 Oct 2024 19:39:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 485771F248D2
	for <lists+live-patching@lfdr.de>; Mon,  7 Oct 2024 17:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976D41DD9D8;
	Mon,  7 Oct 2024 17:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igoMOqCW"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7041E1DD9D3;
	Mon,  7 Oct 2024 17:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728322751; cv=none; b=HzSsg5h45NBWsqWpyt1AfveyONZY4piRzmVYW0n2ZQSBy8afEYED34EIAhdcm7jndnwfRU/InASl83HflLlW8mtBbS4PlR9SPAr/FDd3mzrrfMHgcfybrHCaZ0Q9LXPOxh0/LoA0VozYjf5bNfEjiqv54xdHyrIvG2ES4hRJhsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728322751; c=relaxed/simple;
	bh=UsQTWTTmOUQvjLn0FXOgtma+hJGzYMhIV5HoTnQzEbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dFGfL08B0UC38SXPCa4H34Pil9+E/2Stgw0bWYoj1Cbyvjx7YG9cUYZW4Jp5bPvaa4gyiy8vtnhmmGFR+SMrPazczOpHYuByjnkvkIOL1Pt46jLWCePNoHkqe01Uq4RXmTUJuFqrlnITnZPSGYGvO+4I2lubnd33cL7yglYsbhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igoMOqCW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9FFC4CEC6;
	Mon,  7 Oct 2024 17:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728322751;
	bh=UsQTWTTmOUQvjLn0FXOgtma+hJGzYMhIV5HoTnQzEbg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=igoMOqCWu8ODxIM6O5oGy1iKBlCzoqE7xugmBWoDpYn+GQiQGhK/gEUrp0r5lHWTh
	 qGgDzwbjzvaadZWTWutNbts0Z5EW200Fzp+EALxQDCH123A/S/mBeZKOtT7onn4wG1
	 UWimbEf9pXf7x8wYo12dCyfp0IIyVACrf3WtJzkvlKMMmHMIZLOn+P338OuuK9jLWW
	 GSBkEbXN4+sLkWplUSjD8hB3sWwnbvpoPW517Iz5mrBTnjWedCBw76TVVVWQcgY4QU
	 nmBC1j7DetG1lz6IpbXHPAt8UW99/gm4Ft2zPsMcJ36OG4AQo5t/hxBlQhldmCVCpX
	 VpqgNTJnMN3rQ==
Date: Mon, 7 Oct 2024 10:39:09 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: mbenes@suse.cz, jikos@kernel.org, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: livepatch: add test case of stack_order sysfs
 interface
Message-ID: <20241007173909.klwdxcui6slmod2a@treble>
References: <20241007141139.49171-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241007141139.49171-1-zhangwarden@gmail.com>

On Mon, Oct 07, 2024 at 10:11:39PM +0800, Wardenjohn wrote:
> Add test case of stack_order sysfs interface of livepatch.
> 
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> ---
>  .../testing/selftests/livepatch/test-sysfs.sh | 24 +++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
> index 05a14f5a7bfb..81776749a4e3 100755
> --- a/tools/testing/selftests/livepatch/test-sysfs.sh
> +++ b/tools/testing/selftests/livepatch/test-sysfs.sh
> @@ -19,6 +19,7 @@ check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
>  check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
>  check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
>  check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
>  check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
>  check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
>  check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
> @@ -131,4 +132,27 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
>  livepatch: '$MOD_LIVEPATCH': unpatching complete
>  % rmmod $MOD_LIVEPATCH"
>  
> +start_test "sysfs test stack_order read"
> +
> +load_lp $MOD_LIVEPATCH
> +
> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
> +check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"

At the very least this should load more than one module so it can verify
the stack orders match the load order.

-- 
Josh

