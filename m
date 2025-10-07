Return-Path: <live-patching+bounces-1731-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D844EBC243F
	for <lists+live-patching@lfdr.de>; Tue, 07 Oct 2025 19:38:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 853E934F58A
	for <lists+live-patching@lfdr.de>; Tue,  7 Oct 2025 17:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E6C2E7F3A;
	Tue,  7 Oct 2025 17:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ToFIbNOl"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9A32DAFCA
	for <live-patching@vger.kernel.org>; Tue,  7 Oct 2025 17:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759858733; cv=none; b=Ykqw2ImhjmAp+7RlhlTCs5I8etl4VMujUgGbNYckmnOhAqR7vCUoQqJfPPG24+CdHXUHtFJafIJPyJq175UbwmBA/GsgapBau05E4ClLWOcpJg7pXu5rP1PFJ/U/RBEYEsgkn8jU4bz7DfgRfggMS/tU7t9ysvMTM+BWXfMFhwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759858733; c=relaxed/simple;
	bh=4f5m/uwaK79EoVlKmz9XfQ3+vrh/0FrCxlw67xGiaJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7VlaG+J2Y4msEuJ/6jzMevSahkMqFBy/wtHskGmF1R/DGt3vPENPc0iILwD9Qqx+ZzIL9yfq5VN2+DiVIgotvkiHnOXiGVxYg82cbFNHxBTuV2ptD+i0qJnDMm4j6GhAAzljT7a/Rkjp3BNbI4qfqgRcGyZT7harBJwKQtyNts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ToFIbNOl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759858731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=28xIGnBY+VBsKXwcV2Vk4OkuQMCSFHqLt8ZoR0mFU8g=;
	b=ToFIbNOlKx2aFSeBfdpu2SQn3KMMaWo5TkMa/TjQIhnc/NZDPPnyDMmdAkLuAi8dxX+nIP
	/dFYC3rXmuoE5CUSx6DTr/NVGNpwOLgWgoK4lgHBMlFeXuF7ROIT5s1eSBnm1S5aqAyzYg
	dSIhpWhCv6qRYAPIHKek79RHQL9nJ9A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-306-oP3rQwPOMHyeSFapgLtUGw-1; Tue,
 07 Oct 2025 13:38:47 -0400
X-MC-Unique: oP3rQwPOMHyeSFapgLtUGw-1
X-Mimecast-MFC-AGG-ID: oP3rQwPOMHyeSFapgLtUGw_1759858725
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1511418004D8;
	Tue,  7 Oct 2025 17:38:45 +0000 (UTC)
Received: from redhat.com (unknown [10.22.89.83])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D263219560A2;
	Tue,  7 Oct 2025 17:38:40 +0000 (UTC)
Date: Tue, 7 Oct 2025 13:38:38 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 00/63] objtool,livepatch: klp-build livepatch module
 generation
Message-ID: <aOVQHknMHwBFmJeg@redhat.com>
References: <cover.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Sep 17, 2025 at 09:03:08AM -0700, Josh Poimboeuf wrote:
> Changes since v3 (https://lore.kernel.org/cover.1750980516.git.jpoimboe@kernel.org):
> 
> - Get rid of the SHF_MERGE+SHF_WRITE toolchain shenanigans in favor of
>   simple .discard.annotate_data annotations
> - Fix potential double free in elf_create_reloc()
> - Sync interval_tree_generic.h (Peter)
> - Refactor prefix symbol creation error handling
> - Rebase on tip/master and fix new issue (--checksum getting added with --noabs)
> 
> (v3..v4 diff below)
> 
> ----
> 
> This series introduces new objtool features and a klp-build script to
> generate livepatch modules using a source .patch as input.
> 
> This builds on concepts from the longstanding out-of-tree kpatch [1]
> project which began in 2012 and has been used for many years to generate
> livepatch modules for production kernels.  However, this is a complete
> rewrite which incorporates hard-earned lessons from 12+ years of
> maintaining kpatch.
> 
> Key improvements compared to kpatch-build:
> 
>   - Integrated with objtool: Leverages objtool's existing control-flow
>     graph analysis to help detect changed functions.
> 
>   - Works on vmlinux.o: Supports late-linked objects, making it
>     compatible with LTO, IBT, and similar.
> 
>   - Simplified code base: ~3k fewer lines of code.
> 
>   - Upstream: No more out-of-tree #ifdef hacks, far less cruft.
> 
>   - Cleaner internals: Vastly simplified logic for symbol/section/reloc
>     inclusion and special section extraction.
> 
>   - Robust __LINE__ macro handling: Avoids false positive binary diffs
>     caused by the __LINE__ macro by introducing a fix-patch-lines script
>     which injects #line directives into the source .patch to preserve
>     the original line numbers at compile time.
> 
> The primary user interface is the klp-build script which does the
> following:
> 
>   - Builds an original kernel with -function-sections and
>     -fdata-sections, plus objtool function checksumming.
> 
>   - Applies the .patch file and rebuilds the kernel using the same
>     options.
> 
>   - Runs 'objtool klp diff' to detect changed functions and generate
>     intermediate binary diff objects.
> 
>   - Builds a kernel module which links the diff objects with some
>     livepatch module init code (scripts/livepatch/init.c).
> 
>   - Finalizes the livepatch module (aka work around linker wreckage)
>     using 'objtool klp post-link'.
> 
> I've tested with a variety of patches on defconfig and Fedora-config
> kernels with both GCC and Clang.
> 
> These patches can also be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-v3
> 
> Please test!
> 

For v4.1, with several dozen small, CVE input patches and gcc 14 +
CentOS-Steam-10 config:

Tested-off-by: Joe Lawrence <joe.lawrence@redhat.com>

--
Joe


