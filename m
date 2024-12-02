Return-Path: <live-patching+bounces-872-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E50139E006E
	for <lists+live-patching@lfdr.de>; Mon,  2 Dec 2024 12:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA5391642B4
	for <lists+live-patching@lfdr.de>; Mon,  2 Dec 2024 11:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84452204F77;
	Mon,  2 Dec 2024 11:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b+NmZeWJ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C3A2040A5
	for <live-patching@vger.kernel.org>; Mon,  2 Dec 2024 11:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733138358; cv=none; b=WrcjYJ7vQny00FFUx8vOe1Vyo8q+BalCBUlzy4ks+58MJRJANeBoRkBvOydClSVJy00K9UBe/CYLA+w1ke6tEQlPZsb8PbirjEkLOWIqmK9648ex2/GYAHmJnb8CSrsFNVjGolj+1ygdL3PRC1vVP7A1ez5/0uPhYk3NWepuymo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733138358; c=relaxed/simple;
	bh=UDkly40TtE5zs/2psbTPPKDXYILvvesF9HODlMII3Og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mb4CTi+xYOaeRjs9EipI4NZ+HJ5rSTnWhxB0Cy0Skt0oVLUQcfE6jUA+SiQ7Q6+JUrptSLsf90UhnXHDGAkP56+NEeL7RidkEr/z/NV7/6S0h+ZfigO7/2y+lNWvdN6lw+uxFS8XX1fhc5Go48Kbqnm1x/sEea3o919y3aqO6N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b+NmZeWJ; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9a0ef5179dso611844866b.1
        for <live-patching@vger.kernel.org>; Mon, 02 Dec 2024 03:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733138353; x=1733743153; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vcn7h2SUgJyhRfUcV2fZ7t39o8oNaSoR0j4YwtA48gc=;
        b=b+NmZeWJ80J70T8y3jZ4dPUKndHCBAwHUku7qdVbkndxpre1isl9mMwwiurqu2HJ/1
         ti4OcHhbSiElL34Y6gh68GFpfjaN4VukUP7SSwzQiIMTUVHB80/Fly8gSzUXNyOd9OLN
         ML2SXiyhTwP882GqXZkT0cHP/G/FNMMjcKiC+WTYp9ZUDk9QTu0n+viQ8NV9tglHjp5R
         7PpgLUe1lgypXmZWCwEQYwpMxeyLAxYGTfzhurciFFPlAqw0qq5dSt0Idz2okqyoxn0s
         eyiqvRD4zaIps3PGOr03Ie/IZ1q4xmSOfetm7S8htilYeS5TSfMfCcain6E+Mu7o7V+Q
         j31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733138353; x=1733743153;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vcn7h2SUgJyhRfUcV2fZ7t39o8oNaSoR0j4YwtA48gc=;
        b=cCdJxzmc9t7kbJbule3hbAAFLJla4puAj3988HgRdtSPTvadg4+Fp6AF8Cahh7I+Ys
         euMlSRRr60VQpULCwC9GfX9WtGMJbzrTJsfurRB4SrFkeE1gdw+K3xmcUrO5PD0CxphF
         XMGO9MN68lUxtjgZPjV+aNSxrZWCk2+UhEfcrbCRUTZQgteOXgftDxPkjipPKSunIz6G
         fr6Y2r5w0gNta9CXbndFY2HlWggHwxd0a0L+E51WWpgg9e6vgXUW04cqITy1BcGVF/ND
         dDzJTpOPM/+X783BYkW3q9gpu79pdx9o4jLmP83xqqBjfIcLAmuCyAhA3w6ZcnrRSrTw
         rlEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyJYYSFC1lWB9nxZnbLkdnQ1xVEMyO4J8ylAxbu1Afpv4VZPpPGwybTZssVQXZNLIQournlM5iuxf2Ruwr@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1cOYNMKtFLt8C5K8CJlOdioO7oX/frV8DwB9cY3iTda8SwPFr
	BgyromMMbGUfDRHiCoc792EZRJFTrROYVMg+4Vo27eCqxr/B13PpWgUbu7XS/iQ=
X-Gm-Gg: ASbGncvTCG4V2abDO+q9yZLh0+p/ZWxhIn2/Z5uVJ7gF8DstzeGFZr6UKSYL+N4IDfx
	giiN03oK5hnyOWKTqeZwaJFoL7zd8F5wkm6AxtOgYVzRTblbaHP//RgLQDEZvinU1jthTuqhWsN
	TLHPlEnjpRZ1BK3WSl5DSKH3lHqsvXm/EY/5SpNlUDI3oao1qJPgbv5atILQG0lQ4cI7idR5MEk
	EzT0iLktuVGEXRibv5DNSj7F0tfDSE4QkZfQ4A1cv7MvGokWsQ=
X-Google-Smtp-Source: AGHT+IGrHk2TNn8u7iJFAgIJqEDQIqqsYlNpumxpV+QMRsW0RtgficviCeiMEXouIkFntsVJygDGQA==
X-Received: by 2002:a17:906:30d7:b0:aa5:b639:e2f0 with SMTP id a640c23a62f3a-aa5b639e8b1mr867113966b.35.1733138353674;
        Mon, 02 Dec 2024 03:19:13 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa59991f215sm496596466b.158.2024.12.02.03.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 03:19:13 -0800 (PST)
Date: Mon, 2 Dec 2024 12:19:10 +0100
From: Petr Mladek <pmladek@suse.com>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] selftests: livepatch: add test cases of stack_order
 sysfs interface
Message-ID: <Z02Xrol9cOCCZdde@pathway.suse.cz>
References: <20241024083530.58775-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024083530.58775-1-zhangwarden@gmail.com>

On Thu 2024-10-24 16:35:30, Wardenjohn wrote:
> Add selftest test cases to sysfs attribute 'stack_order'.
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

Looks good to me:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

