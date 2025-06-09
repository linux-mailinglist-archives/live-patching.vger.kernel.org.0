Return-Path: <live-patching+bounces-1506-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 981E6AD2AC1
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 01:59:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EDBE18912C3
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 00:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26EB922FE10;
	Mon,  9 Jun 2025 23:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9sTfWQM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F136322FAC3;
	Mon,  9 Jun 2025 23:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749513581; cv=none; b=c9oByJgzo6B4Lgk7xJ2MxEbjLOl/YL2sS44ufeZtLWje1MPPyZGxGikcsAZk9LB760OyevwKoCT7TIc6xus8ZygQteO1oPDrp6jdJ4uOABzudwM4dbDBVNgXvzR5XTaNtTunF9rRf6ab9PdT+8e0IZ2x19ZUmXWMlcdzAAlnwc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749513581; c=relaxed/simple;
	bh=RaJ4JP9T2aU4aHG/dNUa0jFBPbZWiqCld3IAmeNk0ZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/qq1muHda5LtPYYa3aW53ZLgJyyyFXhf38rnGMOo0ekfbk2xeLQnQ/z0QEB6Sv6b1vfdbtMQi8kFOoAlW26HcQWwvdsKx5Ax8UAdp82dg/7kcP4YQ3ESFOFU9EziwpwvvPqPCh9irJIrL/cx+6zoQuo1/sqvaHUwqs1OVGtwK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9sTfWQM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A192C4CEEB;
	Mon,  9 Jun 2025 23:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749513580;
	bh=RaJ4JP9T2aU4aHG/dNUa0jFBPbZWiqCld3IAmeNk0ZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q9sTfWQMwyVwQmY6VmUr8/dw4bKcX1WG1SOo8HOdUMKr2+yfAiCV4JCZjNFNDvZDb
	 D9+RXyfyBuRh7E56kgIHlfYzYATTk/aKtvMrDOMn8KhPaaeZlMiKDMexv6TibIEkqW
	 WD6/wQcZCv3K9jQqFVM3rSh+nAfBu0jfTXHxzJMyzmoqSiFkOG9OhdVEzVjhxQtxtb
	 XJxAycVLLYJtyK/G99wgUquJZsA5p43JCTlSaRFaNosiTrjqTM+RzGBvpklpcl7R+7
	 /5k2bGjMeDhpo1kbL4k7DR878gOA5eSgamnJ3+8K4+l0mMpaHUUmnwvP89IEF1UoI7
	 5Q0kDzGocKZ2A==
Date: Mon, 9 Jun 2025 16:59:37 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
Message-ID: <7uriarhovgf3fp7tiidwklopqqk34ybk6fnhu6kncwtjgz2ni6@2z7m42t4oerw>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
 <aEdQNbqg2YMBFB8H@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aEdQNbqg2YMBFB8H@redhat.com>

On Mon, Jun 09, 2025 at 05:20:53PM -0400, Joe Lawrence wrote:
> If you touch sound/soc/sof/intel/, klp-build will error out with:
> 
>   Building patch module: livepatch-unCVE-2024-58012.ko
>   ERROR: modpost: module livepatch-unCVE-2024-58012 uses symbol hda_dai_config from namespace SND_SOC_SOF_INTEL_HDA_COMMON, but does not import it.
>   ERROR: modpost: module livepatch-unCVE-2024-58012 uses symbol hdac_bus_eml_sdw_map_stream_ch from namespace SND_SOC_SOF_HDA_MLINK, but does not import it.
>   make[2]: *** [scripts/Makefile.modpost:145: /home/jolawren/src/centos-stream-10/klp-tmp/kmod/Module.symvers] Error 1
>   make[1]: *** [/home/jolawren/src/centos-stream-10/Makefile:1936: modpost] Error 2
>   make: *** [Makefile:236: __sub-make] Error 2
> 
> since the diff objects do not necessarily carry forward the namespace
> import.

Nice, thanks for finding that.  I completely forgot about export
namespaces.

Can you send me the patch for testing?  Is this the default centos10
config?

-- 
Josh

