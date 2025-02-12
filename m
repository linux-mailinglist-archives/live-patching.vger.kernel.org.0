Return-Path: <live-patching+bounces-1152-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 066EEA31ADB
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 01:52:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 799831889092
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 00:53:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CA65F9D6;
	Wed, 12 Feb 2025 00:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eX9PiYof"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7814C27182B
	for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 00:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739321575; cv=none; b=bmPC1S+snDyMrY+gCHwjzxoijcdUtamapSWnvHKwBvwu1GNDzDgNzZVgOfFujkkYp1UzRUBa4GIcfVQEL1Wbq9jw6GKU1fybqbF/ChJlKK7+0ozUUUt5G5fWTtoB3iua6Bjui792SvVSQKe6SL7m6eX+vBfQip7BxKwWGLDDTSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739321575; c=relaxed/simple;
	bh=KroWA/EUy4urQEkNQ7tnbRPRUl5IBNSI/vXekvZfy2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mc3Vsdv0CWU3HL/fOXbUKbbI3IgD4Z2Ig2KMZQqvoIdIBPSHSIGzDi278CoT0xGus9IMgd2zkwEfuykdjiG1TtbifoMQge6KWw0KyAqOLOo9tmgEc31Rmp6ck3H/jL6S+opaFtaRk5pcBMyxxgC745XPUxX3uHYSM/jpkPpJ/Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eX9PiYof; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD75C4CEE2;
	Wed, 12 Feb 2025 00:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739321574;
	bh=KroWA/EUy4urQEkNQ7tnbRPRUl5IBNSI/vXekvZfy2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eX9PiYofQs+Awgr2SgPBOdFtriO25JW8gGLAfEYGYd/xhbXnC+eJ9Bkc+VuuaYaD9
	 tmPTrSrf8b+nDEeCl47Rf2uQKgJ2zI4yLwicbVPsdYUUzULgP2Ju4C59IOlkJfvFR9
	 TSuDxtUDWyO+j+VpBX3YY/VCnCGpGvzz/1VRVWE6CYIliXMn7bYvosJqezWz/TQjsi
	 mqsLdfdVM3k/1ltdHm4Qli36/llKkqTEUbdHAjHrUndWHka0thB8sBS5zIS6sWyuZx
	 s3mF3XuQ/jhRqpjZCGaOMnZJJPasWF9rWlL5verRePeJokNl+aW5QLE8x8WIQZdTkO
	 1FqL1o085KtYw==
Date: Tue, 11 Feb 2025 16:52:53 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH 3/3] livepatch: Avoid potential RCU stalls in klp
 transition
Message-ID: <20250212005253.4d6wru5lsrvxch45@jpoimboe>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-4-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250211062437.46811-4-laoar.shao@gmail.com>

On Tue, Feb 11, 2025 at 02:24:37PM +0800, Yafang Shao wrote:
> +++ b/kernel/livepatch/transition.c
> @@ -491,9 +491,18 @@ void klp_try_complete_transition(void)
>  			complete = false;
>  			break;
>  		}
> +
> +		/* Avoid potential RCU stalls */
> +		if (need_resched()) {
> +			complete = false;
> +			break;
> +		}
>  	}
>  	read_unlock(&tasklist_lock);
>  
> +	/* The above operation might be expensive. */
> +	cond_resched();
> +

This is also nasty, yet another reason to use rcu_read_lock() if we can.

Also, with the new lazy preemption model, I believe cond_resched() is
pretty much deprecated.

Also, for future patch sets, please also add lkml to cc.  Thanks.

-- 
Josh

