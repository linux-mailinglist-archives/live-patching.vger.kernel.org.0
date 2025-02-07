Return-Path: <live-patching+bounces-1125-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA5BA2B918
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 03:31:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 167E2166015
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 02:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3307E0FF;
	Fri,  7 Feb 2025 02:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FV2oqP0M"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E367E9;
	Fri,  7 Feb 2025 02:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738895479; cv=none; b=cRfE1twlEN8kRDylhIe2NPSKeT3dArIr5gt/PYSFtVDsD0vQ+5fEZ4MkeQUDUDfzzgG93A391Vr8Aw8xI7tVFYxgA1CR1cHStuhPJKAOoHjg0cz1B/Zvoc71ue6x/SzzDdfG6Pt43AuPUGanz6dswPSdiT+3uImvLqC1yeDeC5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738895479; c=relaxed/simple;
	bh=v3Dwj5P8+6TcrtdFSb7zHWGNAfHPcBq2KJLBbk0zvfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l9aFzNEtyPnJPL55jQNG0oFi4P0v6BRsxVt1gDJ1H92USoB4VcXeFXV7n2n8LrF9OxXnb5hvmjSo7oSH7pLgj4kB4h9w5oTmj9JwV3P2ilo8C2Fg1AN/fiigwsArNNyEdFWLT/vNTiYeNurEgnm7z9h0TPwtQuYIVMZi1zrue3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FV2oqP0M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EEDC4CEDD;
	Fri,  7 Feb 2025 02:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738895478;
	bh=v3Dwj5P8+6TcrtdFSb7zHWGNAfHPcBq2KJLBbk0zvfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FV2oqP0MBJ4++QdGDLK2ctjv8YQMU3FsbKmMVgqLKtwQ76eR1OO4+HAY3dK/lw6yQ
	 p/nP+SprdEYINRhh32ZFYojju08I5b0DYJN6v90vr/5SIx294wtEXw6RvLf77FZbj/
	 4ql5vhzi+HZPrtFB/QVFT4fCiBUVG0xfUJVXVIFvv8uk9Ogt9nsE/YT0nCb2u7M1bg
	 kR3hXgKt23X4IYRVSBuO5fWnFStE+3EvXcO2B3WcJF7X81HvqpfR/6D/cCr/URsht0
	 Q2BguXiK9odcjgXkU0ShiVd9kR6GOkR3S+M1fUFc+SgwlpwF/s3vB12WFeFYjN/CO3
	 2j+YCS7iHERtg==
Date: Thu, 6 Feb 2025 18:31:16 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
Message-ID: <20250207023116.wx4i3n7ks3q2hfpu@jpoimboe>
References: <20250127063526.76687-1-laoar.shao@gmail.com>
 <20250127063526.76687-3-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250127063526.76687-3-laoar.shao@gmail.com>

On Mon, Jan 27, 2025 at 02:35:26PM +0800, Yafang Shao wrote:
> The atomic replace livepatch mechanism was introduced to handle scenarios
> where we want to unload a specific livepatch without unloading others.
> However, its current implementation has significant shortcomings, making
> it less than ideal in practice. Below are the key downsides:
> 
> - It is expensive
> 
>   During testing with frequent replacements of an old livepatch, random RCU
>   warnings were observed:
> 
>   [19578271.779605] rcu_tasks_wait_gp: rcu_tasks grace period 642409 is 10024 jiffies old.
>   [19578390.073790] rcu_tasks_wait_gp: rcu_tasks grace period 642417 is 10185 jiffies old.
>   [19578423.034065] rcu_tasks_wait_gp: rcu_tasks grace period 642421 is 10150 jiffies old.
>   [19578564.144591] rcu_tasks_wait_gp: rcu_tasks grace period 642449 is 10174 jiffies old.
>   [19578601.064614] rcu_tasks_wait_gp: rcu_tasks grace period 642453 is 10168 jiffies old.
>   [19578663.920123] rcu_tasks_wait_gp: rcu_tasks grace period 642469 is 10167 jiffies old.
>   [19578872.990496] rcu_tasks_wait_gp: rcu_tasks grace period 642529 is 10215 jiffies old.
>   [19578903.190292] rcu_tasks_wait_gp: rcu_tasks grace period 642529 is 40415 jiffies old.
>   [19579017.965500] rcu_tasks_wait_gp: rcu_tasks grace period 642577 is 10174 jiffies old.
>   [19579033.981425] rcu_tasks_wait_gp: rcu_tasks grace period 642581 is 10143 jiffies old.
>   [19579153.092599] rcu_tasks_wait_gp: rcu_tasks grace period 642625 is 10188 jiffies old.
>   
>   This indicates that atomic replacement can cause performance issues,
>   particularly with RCU synchronization under frequent use.

Why does this happen?

> - Potential Risks During Replacement 
> 
>   One known issue involves replacing livepatched versions of critical
>   functions such as do_exit(). During the replacement process, a panic
>   might occur, as highlighted in [0]. Other potential risks may also arise
>   due to inconsistencies or race conditions during transitions.

That needs to be fixed.

> - Temporary Loss of Patching 
> 
>   During the replacement process, the old patch is set to a NOP (no-operation)
>   before the new patch is fully applied. This creates a window where the
>   function temporarily reverts to its original, unpatched state. If the old
>   patch fixed a critical issue (e.g., one that prevented a system panic), the
>   system could become vulnerable to that issue during the transition.

Are you saying that atomic replace is not atomic?  If so, this sounds
like another bug.

-- 
Josh

