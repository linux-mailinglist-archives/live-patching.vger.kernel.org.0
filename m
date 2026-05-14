Return-Path: <live-patching+bounces-2812-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLJkNobfBWqjcwIAu9opvQ
	(envelope-from <live-patching+bounces-2812-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 16:43:18 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B62F54358C
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 16:43:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CEC5A306CC8B
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 14:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4D13E5560;
	Thu, 14 May 2026 14:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EbCH9f7V"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EA53DFC6B
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778769320; cv=none; b=S4oa362DyMxE63ZLaIKWyckLgW7k1kLol4KAkF/B5HTcj8IA2TiKoC2n17R88RqVZCD41mfLIWKAxqGc9uVto3tvTnCvHhjv3feaA5zQ1ZDUsqyBEJFNTbCz+y1kfWf8uAlYfY/wHi1pITJ7mQo/+wbS0MDpxjgG9pwJ5mHLt88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778769320; c=relaxed/simple;
	bh=XFku5yzYOiAWkNshlk1RONi26wOOTtlVdHy89dww+pw=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tKgWRetFHA+N4HTZgcmvU5UspQHab+CrOh3o6ZOdQizeVbpp82gOc2rdTI7JATOTJ/zkIIB25K0h01Dx8f2zuT7AlBamVudF0go95IJT2hDxDZ+4Iq7j3B0MflI/otqemfpjeWrc9+xnH/xxPJI0ThQauoH5ZdLFM26mNCb5zgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EbCH9f7V; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43d76dd4ee8so7478997f8f.2
        for <live-patching@vger.kernel.org>; Thu, 14 May 2026 07:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778769318; x=1779374118; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s/Z4/+H7H1VVZuahgNCo5Gog19+W4f6AXOwm3rTI+q0=;
        b=EbCH9f7VXhl4iMUnJhrh4wHgMJ3qIumD8DgKlFca+XaCTqZNQeGFu78onpDkbWxcmd
         L/JYhdp0EhYSLqPhlraBZfLrUjTAhJ+P6OeE2esjOh/Vgwie4XH/Fr6F8DabbH6c+dHZ
         4tn7qbXi3LTQg60/BphAJRfJ13uAB3jkc47uKEtEvCGZUlH8q/X+AylcW8uUihIExvb7
         0+FeFiBnVHjWrstRvshoCqSJQCTQJ/F80wMejS/GBvTWY5Oi3jcNRiqjNy8E1ukSpFgf
         PIxpCRlFHwqf9RLpVPh/OPZyIxJzLTtcG/P0htmJJEFtX3HvFRL1U0lRTGG6HEj3QP3B
         97cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778769318; x=1779374118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s/Z4/+H7H1VVZuahgNCo5Gog19+W4f6AXOwm3rTI+q0=;
        b=Csp5WFWIUnkx9kkYzmITwKJ6WnCAZigYDqydyKROCC8xevKI6Ed9QBEPEj2g3PRK+K
         PozMTu6t4SuJVqujs95edMTYf8jsNFY115OYI9w/tY9ALsmn8Kj2/YON0KmD0xrxhw6O
         YZ+IrzAxGNUkq4Zgp6qaCGM8H5elGtylJO1d9ZcAzqbxvuBFkV7xPtj+I4nbI9AnoNfx
         1zSvZju/ieWuti3FoX6mFrzohXibW4I89n5lOoU7D5gx9hJWhyj6Vp4dFWCBYRrdwO+C
         FEOXsn3CLnFboS3Ec+3k810un/Tdgd2hRBD+JjdwIofYmH1yv1DX61HGOpVxuRLAA0oE
         3d4Q==
X-Forwarded-Encrypted: i=1; AFNElJ89/V9vOJv/dYyX8sTT69NkyH87CplEkI5MP3PcA0z7awkr+Jel2ms9+ZqEqxTEfNUUHsAh72zqup+H3Sob@vger.kernel.org
X-Gm-Message-State: AOJu0YydXqjaK3tOax+ClOPS0/EdMaCazVjkWqB+Wy064SRB5JaTE8Ai
	W3Vtme5fbBOD65cvftc9eJbE6gpxBARVFcX/nJ6CmdChNiMOo1Tbi1Jr
X-Gm-Gg: Acq92OHwH2SnZWK8lOUt5i8ySTP6yaCVwYgaSA6GDWIjZmolXCrbfuDrLNrlcI9qvTW
	GmDfLSdMk1NXQ67x3DPVQxoZRzPr8QENlTj154Sq8pi4fYCy7r/08Y0m8KO2EnoyQOKIDEIfUr2
	EzfmPlj6jGOzzDEot6CuokVjwylTMdXRq1priyLGubYdW8c2LESb12ZCh6KC93XYlhYIb67GR4X
	2C6tAT3zhX1iVc+WL5gU6mcK6+K8S1gQHI3P7LJnKtfskGby1WCrRjX8vpznqgEujzeL0uJT45E
	dOF7aw/lyU50P5BVwnUPytBHG1yA59wkT/oLyYhXTUBBRZMdEBUCHIL/0DTlp/YnuLbAoKGYHiz
	nsZpTX4Jl1rnqV+K5+PP+6eEtnBy24vg15usGERP+lt8j5sL7RKMf2GvVd2qlnzDYX9tYTgGiSm
	yyABgEriuphWK2pM3C0dDfTOIG4lY7YHUNepau
X-Received: by 2002:a05:600c:46d2:b0:48f:c903:955f with SMTP id 5b1f17b1804b1-48fc9a4c78dmr120777745e9.23.1778769317918;
        Thu, 14 May 2026 07:35:17 -0700 (PDT)
Received: from krava ([2a02:8308:a00c:e200:b655:ff13:e355:16a3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe46d8daesm1231655e9.9.2026.05.14.07.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:35:17 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Thu, 14 May 2026 16:35:15 +0200
To: Sasha Levin <sashal@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Breno Leitao <leitao@debian.org>,
	Andrew Morton <akpm@linux-foundation.org>, corbet@lwn.net,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	gregkh@linuxfoundation.org, akinobu.mita@gmail.com,
	live-patching@vger.kernel.org
Subject: Re: [PATCH] killswitch: add per-function short-circuit mitigation
 primitive
Message-ID: <agXdowd63K8j43xi@krava>
References: <agHUp8ulaWJ75WU5@tiehlicka>
 <agHcFCRVSn5ra5Kc@laps>
 <agHeZPA3eHhJHIsQ@tiehlicka>
 <agHgDgwu8H9Opzpl@laps>
 <agHm9Vj7bPPCRS1g@tiehlicka>
 <agH7_QBPLWKTZucB@laps>
 <agH_bGUTvWm2h5g4@tiehlicka>
 <agIHsN9tiIHnVTeV@laps>
 <agINlnNN4ubZgyiN@tiehlicka>
 <agIbaeBQAr-RkqYc@laps>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agIbaeBQAr-RkqYc@laps>
X-Rspamd-Queue-Id: 9B62F54358C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2812-lists,live-patching=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_CC(0.00)[suse.com,debian.org,linux-foundation.org,lwn.net,linuxfoundation.org,vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[olsajiri@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Mon, May 11, 2026 at 02:09:45PM -0400, Sasha Levin wrote:

SNIP

> > > Even if I'm okay with rebooting that often (and I really really would prefer
> > > not to), this doesn't solve the issues of a larger fleet of servers that can't
> > > just reboot that often.
> > > 
> > > What am I missing?
> > 
> > For one, you are missing more maintainers of code modification infrastructures.
> 
> Happy to add more, but I don't want to be too spammy. I'll add in the
> livepatching ML and the fault injection maintainer (I couldn't find a list).
> Please add any other folks/lists who you think might want to contribute to this
> discussion.

hi,
could you please add bpf (bpf@vger.kernel.org) to the loop?

thanks,
jirka

