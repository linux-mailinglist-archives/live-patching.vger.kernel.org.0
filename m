Return-Path: <live-patching+bounces-600-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EB1996C90E
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 22:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32F161C253D5
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 20:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C37413D29A;
	Wed,  4 Sep 2024 20:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kVgtc4h8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CF413B780;
	Wed,  4 Sep 2024 20:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725483592; cv=none; b=UsB+/MWz7VRmhXVhw0LkixetfZea9j4fOhpphYmwyOwXQk/Yd7GmVFQsmyM1DA97Aw+3eV5jIDs0PeKldw+kN2XxTpx2HGkyav63A2Yg4TiLEW05NHfDw+eX9d0HYXFqbF21UCsTs6XkD0wuh7DLSIPh9LMEmzZ5YLl11Za2OvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725483592; c=relaxed/simple;
	bh=zEdO8V23Ajwmty7u5XyD8wfm/RpJcb+ugA3N0/oStsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r+yINkNuUrn/PdduyOnNf/O7ladlrdnCq+HNwGikwZttigZdVHaJycmNIjwDAW7hsE05T3I9jLUlRUyWME3c03QIZwBpQOHYQF3HjVbuPy2WtAeqgD6DDMrtIdHSzqWR7ubuojEezMTkGBGCTKqhK0ptIqvwrkxRKmV9p31uHJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kVgtc4h8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2089EC4CEC2;
	Wed,  4 Sep 2024 20:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725483591;
	bh=zEdO8V23Ajwmty7u5XyD8wfm/RpJcb+ugA3N0/oStsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kVgtc4h8Terhog5EC1+XdUk9Xrg/KV+YxmYWI7bWdVt36rw9v88R5QVrfI967YAoh
	 ohtHj7pvjR/z4GunJlh42yQ2DHpLhaVWrf6xk3XJTU4EM1+Dpv1q8YQeNFTiq3J5+U
	 mBi8w/m50/0sDLdJWWoDigDAEKCKZy9AnilxSemmaohCBhOsoDnv395o7/2DFpo43D
	 vMJJscT+/2p1NkZXygufUcD3ahXFWnObSYq6cK/+OOETjOYtGIApKTUKgvF9R7aRTN
	 /pGInDPaCeon5xII46vqnQWuckAMMnFU2nUUld0w76FLZY7sp/wTwlbRJGjJF6nNgu
	 L4tJxawuCRiGA==
Date: Wed, 4 Sep 2024 13:59:49 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <20240904205949.2dfmw6f7tcnza3rw@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
 <20240904043034.jwy4v2y4wkinjqe4@treble>
 <CAPhsuW6+6S5qBGEvFfVh7M-_-FntL=Rk=OqZzvQjpZ6MyDhNuA@mail.gmail.com>
 <20240904063736.c7ru2k5o7x35o2vy@treble>
 <20240904070952.kkafz2w5m7wnhblh@treble>
 <CAPhsuW6gy-OzjYH2u7gPceuphybP8Q43J9YjeUpkWTh5DBFRSQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW6gy-OzjYH2u7gPceuphybP8Q43J9YjeUpkWTh5DBFRSQ@mail.gmail.com>

On Wed, Sep 04, 2024 at 01:23:55PM -0700, Song Liu wrote:
> Hi Josh,
> 
> Thanks for the fix! The gcc kernel now compiles.
> 
> I am now testing with the attached config file (where I disabled
> CONFIG_DEBUG_INFO_BTF), with the attached patch.

Probably a good idea to disable BTF as I think it's causing some
confusion.

> The build was successful:
> 
> $ ./scripts/livepatch/klp-build 0001-test-klp.patch
> - klp-build: building original kernel
> - klp-build: building patched kernel
> - klp-build: diffing objects
> vmlinux.o: changed: bpf_map_mmap
> - klp-build: building patch module
> - klp-build: success
> 
> But I am not able to load it:
> # kpatch load livepatch.ko
> loading patch module: livepatch.ko
> insmod: ERROR: could not insert module livepatch.ko: Invalid parameters
> kpatch: failed to load module livepatch.ko
> # dmesg
> ...
> [ 7285.260195] livepatch: nothing to patch!
> ...

Weird, I'll try to recreate with your config (without BTF for now).

-- 
Josh

