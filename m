Return-Path: <live-patching+bounces-414-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6240D93F765
	for <lists+live-patching@lfdr.de>; Mon, 29 Jul 2024 16:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4761B21FC1
	for <lists+live-patching@lfdr.de>; Mon, 29 Jul 2024 14:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5560514EC60;
	Mon, 29 Jul 2024 14:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="Z1Vq4Cmu"
X-Original-To: live-patching@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED4579DC5
	for <live-patching@vger.kernel.org>; Mon, 29 Jul 2024 14:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722262645; cv=none; b=GSa20Ksjfdag3mg2OQslQ4W7gNJ61E8sShINbq5datOPKayRAufbd12BD/5oOPGOSfJ2oqrlO6GeHSxFwLrahaGvZnUPkm239SRM6AwhYMRIMZQnrOtacpOjM2z/RSkS3K59qDGt/JT2trBQWMD8BzZixbilXvTpnSNKj04c+LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722262645; c=relaxed/simple;
	bh=EX0B9S+UuNcc9nwhqXeH6uTbtRokn4/GSUyE86+Y9Tc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GSa9vmGch8pBsyrlLtZ8IBUA7Bayj6I34qSN4dP862Uu4AlRVAGAC5JaLQ3xRG80TU1kEBJUMpyUuwSsj4vWwqIMSivz7GUYatfqdGgNZH3Exf0oS0HoBJBUxln8nhr3rNkVh/puyXMGeKwy490338XY+bXk9mTny9vP6DjkZ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=Z1Vq4Cmu; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1722262639;
	bh=eCNFlbyuvUg9Dr6Km3nJh9bqYmWj+BgQRf4YrHZk1R0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Z1Vq4CmuKHs1HWAwpmMP+liv5O3VTi1k+f1wjDTlu72cs116wcFbnnSq7L+ZRaVdf
	 DBjpe3NbmEkN9ZvS4cFnKwKbpFVZNMlBCYkgb9Y10KYNb7TVRAXdHezja3NEfIpHKA
	 gI+NRUN1Q3cZgkBPDRe+KANatjKnytRxItQmIvT30MfsUwcezfPNcaT02FtTTALNHv
	 zRJwVOEXWKbZ/UgvVEt31IM6tvutA215KIaeEOGw1Lwp85B2xhFtlTy+juDpxmLdia
	 bdFZ2uLslmRzolrNiGJA0I/3Khbw6KUffchXGNX7+0xsPT5qXRiBQdz5CITlO4n5Ri
	 840OxqxEqauAQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WXgRM3Tb1z4x1V;
	Tue, 30 Jul 2024 00:17:19 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Ryan Sullivan <rysulliv@redhat.com>, live-patching@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
Cc: rysulliv@redhat.com, joe.lawrence@redhat.com, pmladek@suse.com,
 mbenes@suse.cz, jikos@kernel.org, jpoimboe@kernel.org,
 naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu, npiggin@gmail.com
Subject: Re: [PATCH] powerpc/ftrace: restore r2 to caller's stack on
 livepatch sibling call
In-Reply-To: <20240724183321.9195-1-rysulliv@redhat.com>
References: <20240724183321.9195-1-rysulliv@redhat.com>
Date: Tue, 30 Jul 2024 00:17:18 +1000
Message-ID: <878qxkp9jl.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Ryan,

Thanks for the patch.

Ryan Sullivan <rysulliv@redhat.com> writes:
> Currently, on PowerPC machines, sibling calls in livepatched functions
> cause the stack to be corrupted and are thus not supported by tools
> such as kpatch. Below is an example stack frame showing one such
> currupted stacks:
...
> diff --git a/arch/powerpc/kernel/trace/ftrace_entry.S b/arch/powerpc/kernel/trace/ftrace_entry.S
> index 76dbe9fd2c0f..4dfbe6076ad1 100644
> --- a/arch/powerpc/kernel/trace/ftrace_entry.S
> +++ b/arch/powerpc/kernel/trace/ftrace_entry.S
> @@ -244,6 +244,9 @@ livepatch_handler:
>  	mtlr	r12
>  	ld	r2,  -24(r11)
>  
> +	/* Restore toc to caller's stack in case of sibling call */
> +	std	r2, 24(r1)
> +

It would be good to have a comment here explaining why it's safe in all
cases to store the current r2 value back to the caller's save slot.

I haven't convinced myself that it is always safe, but I need to think
about it a bit harder O_o

cheers

