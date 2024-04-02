Return-Path: <live-patching+bounces-214-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F01B18955D0
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 15:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D3FC1C21FEC
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 13:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ADF88405D;
	Tue,  2 Apr 2024 13:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jOR542wK"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8028784FC5
	for <live-patching@vger.kernel.org>; Tue,  2 Apr 2024 13:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712065964; cv=none; b=sO1aBsDttNxrBuJrLvmImoYtKwmouGGKxdlO08C++YJ2Xvd3Hr3ZqoOnI2VKc2Kh/WCu0E5ATDGbaN42616DPG9My69zEYpZkImft+jr8tMnVpQU5Mu6JbsJHqf8cU5Ra4RE7MJlKsIckEZIsKq/4+kmNaMbwPIBFxw5r3BlTLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712065964; c=relaxed/simple;
	bh=DPrcRRAqP1t9Y3kbn2V/yhUWU5FgxTbcD5//bRhvtjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kb2rp3mxuucssJBBNI2wbfBLip3rsHtJDuNgt5r0I+9l/BW+7fkoiElO957ZeLg+945H0ZIf3ulxhvAg6fh2y0wf/aDAgMOa2X6fvovCe/U2uTNNMTewAX40ifRw58glKPAHIdp6UhkssM7bWITdXwtJR7yExZ/g10IySri1rl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jOR542wK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712065960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DhTrdl+Lsun5myVNSpVrwdD2BVn4sbhl051ZYtiso+E=;
	b=jOR542wKwaMLsh3GSNn9MSM1g2ET+gY3th51ecyGPWNd4BgW6zyCJ+Bpn0nbz7d3Eqrt+o
	7KLW+WG7QwGGtRG8tSP/YB2W+7XdaJb0Q/ao9u/cR9g4AfKFzftYXhfQ+AEYTVoC98rK4x
	5COkRbOBYM9S9okzMQoSVa+E0Xz0xDc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-206-V_eTs7JBMga5AQrHxfFSIA-1; Tue,
 02 Apr 2024 09:52:34 -0400
X-MC-Unique: V_eTs7JBMga5AQrHxfFSIA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EB183C025B9;
	Tue,  2 Apr 2024 13:52:33 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.63])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 28A092024517;
	Tue,  2 Apr 2024 13:52:33 +0000 (UTC)
Date: Tue, 2 Apr 2024 09:52:31 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: zhangwarden@gmail.com
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org, pmladek@suse.com,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: Add KLP_IDLE state
Message-ID: <ZgwNn5+/Ryh05OOm@redhat.com>
References: <20240402030954.97262-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402030954.97262-1-zhangwarden@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Tue, Apr 02, 2024 at 11:09:54AM +0800, zhangwarden@gmail.com wrote:
> From: Wardenjohn <zhangwarden@gmail.com>
> 
> In livepatch, using KLP_UNDEFINED is seems to be confused.
> When kernel is ready, livepatch is ready too, which state is
> idle but not undefined. What's more, if one livepatch process
> is finished, the klp state should be idle rather than undefined.
> 
> Therefore, using KLP_IDLE to replace KLP_UNDEFINED is much better
> in reading and understanding.
> ---
>  include/linux/livepatch.h     |  1 +
>  kernel/livepatch/patch.c      |  2 +-
>  kernel/livepatch/transition.c | 24 ++++++++++++------------
>  3 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 9b9b38e89563..c1c53cd5b227 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -19,6 +19,7 @@
>  
>  /* task patch states */
>  #define KLP_UNDEFINED	-1
> +#define KLP_IDLE       -1

Hi Wardenjohn,

Quick question, does this patch intend to:

- Completely replace KLP_UNDEFINED with KLP_IDLE
- Introduce KLP_IDLE as an added, fourth potential state
- Introduce KLP_IDLE as synonym of sorts for KLP_UNDEFINED under certain
  conditions

I ask because this patch leaves KLP_UNDEFINED defined and used in other
parts of the tree (ie, init/init_task.c), yet KLP_IDLE is added and
continues to use the same -1 enumeration.

--
Joe


