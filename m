Return-Path: <live-patching+bounces-1508-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6576AD2BE2
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 04:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E02AC18906B1
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 02:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43871242930;
	Tue, 10 Jun 2025 02:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NaN8RoGZ"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A148A24290D
	for <live-patching@vger.kernel.org>; Tue, 10 Jun 2025 02:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749521684; cv=none; b=h1kChxmcmiukwbMRCkyEPLOwKX3pIsQWt1zOuWYaAT8WQx94rPU9hIXLO02ec7sUEr1Uw7N+BZCV/sA7j23kaNjk2Segiqzt57N+sEUkjwhgnV398eLZSS42yBSht401pgOXjxWkulVEHRWaPNylLYsWjHmn58Yme9qBQm3Xg68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749521684; c=relaxed/simple;
	bh=i4WO5k+tv6XVybLAEBiXR7nxpnWSF5or35FkR1kg+dQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OB/ZAjkJ/4FXkO69vuq+XspcWCfhPefRGJDKt6z8VMa55aRLSJWC3yjK/cdUfHyJ09/pPh78kmfAliEyAdMQIH02Gxk7lJIWSa97OOy2khSViUESOY2LC7hVaQM8MO63UVKzsjsFu50Ng/HrDjo6tcxRqqltrY+JjGlwH/EHCNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NaN8RoGZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749521681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yIBFirwBqY4Xd+zzI6/WHXTGuPu27/Hd5spfFYevmu8=;
	b=NaN8RoGZqjtjcdv5gDBNfgY9zc6HgsgxJ8egctTaUx3idSrAGMjWktSEWGDHkY6x1xsRGR
	HEqWdmxuPKBqTpF5+wqwdxodNurcEPsdmjwKtOimgMJ8u5PQfKxsdlQ8azcu2Y6ZBOAVwU
	LbnbQA2AwRfjtUrhDGefMKpiljK2k+w=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-pn5Rfi7gMh2Ub6S08L-Kig-1; Mon,
 09 Jun 2025 22:14:35 -0400
X-MC-Unique: pn5Rfi7gMh2Ub6S08L-Kig-1
X-Mimecast-MFC-AGG-ID: pn5Rfi7gMh2Ub6S08L-Kig_1749521673
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81710195608D;
	Tue, 10 Jun 2025 02:14:33 +0000 (UTC)
Received: from redhat.com (unknown [10.22.81.60])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C05118003FC;
	Tue, 10 Jun 2025 02:14:30 +0000 (UTC)
Date: Mon, 9 Jun 2025 22:14:27 -0400
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
Message-ID: <aEeVA2dwZPCi8wIe@redhat.com>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
 <aEdQNbqg2YMBFB8H@redhat.com>
 <7uriarhovgf3fp7tiidwklopqqk34ybk6fnhu6kncwtjgz2ni6@2z7m42t4oerw>
 <aEeTAa9qwCSdK9AD@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEeTAa9qwCSdK9AD@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Jun 09, 2025 at 10:05:53PM -0400, Joe Lawrence wrote:
> +		# Copy symbol namespace
> +		readelf -p .modinfo "$ORIG_DIR/$rel_file" | \
> +			gawk -F= '/\<import_ns=/ {print $2}' | mapfile -t namespaces

Errr, that is $PATCHED_DIR/$rel_file if we want to pick up the updated
list of namespaces in case the .patch had amended it.

--
Joe


