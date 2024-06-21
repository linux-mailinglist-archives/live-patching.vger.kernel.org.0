Return-Path: <live-patching+bounces-357-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB41911CE0
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2024 09:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAD64B256D4
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2024 07:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E8912BEBE;
	Fri, 21 Jun 2024 07:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aBOeB+ic"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B27582D68
	for <live-patching@vger.kernel.org>; Fri, 21 Jun 2024 07:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718955121; cv=none; b=DKJ/jsiQswrjMxfcsWYUQLJI3Vrp/ow30PVhtGcbY/kRkIeG/dfxPe0ZMbjOC1k3dEoJ7xU52bC956pcwJLdLtuSkf2rLYof7Br559qjYMiT9w+3JTDR6cSp9uy2XB34YTLmzmfKhHSO7cG2t8gtG8UKRukQGyvIvIa6765g/2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718955121; c=relaxed/simple;
	bh=P0CMYhFYkrzdHLUVAfeFCoeXA77Rn0B1Zm2Df5SesCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZAqP7Ccr/jCB0RAUaR83E26Ipzmed/KPH0p2tUVdFFNZ3dT0o5fW4atdm5X94Fr8AggCKw9K9s+N2UQz9iBug7cYMRSWzspp/a3EhVw/wpeSj5An0v80NklcH56LCs8ZCAUnvtJLuXf8zKZlhYYw8f2alaPvzxxqpTf6rkHIs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aBOeB+ic; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ebeefb9a6eso16287041fa.1
        for <live-patching@vger.kernel.org>; Fri, 21 Jun 2024 00:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718955117; x=1719559917; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JN0/1jFIEsyWQUjfLUa3xCVvfoXN/bM8UwCW1478d08=;
        b=aBOeB+icdi4rIL8URih434FHWudjBDiiISZYqGd7w0s4TvTDmYYqyVf+7MZuflANXI
         6qoOz2YX8FNEWjx58c8unRjAaRsjPurqOoEAM78xQot81tPv+MS4nDgT3LkspITNNDy0
         Nu0DThDVIS0WgYwpr1wKkCzHocInvlfaE2fr0CubGgtlGfTApoTuMu22WVwwDwNUetXj
         QoQp5g8RPezxGMktBFtS68km7sEySQCZ9X+1DLXC2fTlPbNFgGUbTy4dL79/9q2f0h4K
         DUG4OgogqkcaRA7YkB1Oce5kZYQZ5yozn8WswWDjba6K30GqkOxtO3weuf1RpX1ut/x3
         /OYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718955117; x=1719559917;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JN0/1jFIEsyWQUjfLUa3xCVvfoXN/bM8UwCW1478d08=;
        b=sFDs3wzKP4BTe2uyJCCqFbHQE4oX5wL7EXA2sEC2/7Y2mIzsMtovicj+J8uaajCrKZ
         IG/I51vWivvv7FmQtqro7tubc3SRcKBAuSbzSgJrC8SUe7PT5u/sXLUlOfNhXVYOeGdk
         p+iSQLKeHn10lG65uQPu3YFMMjL8FyQBKx6VNDxL8oWohwuDbZbNTjcuSzcE0GdJVAsn
         NufmITfwz0PTK5aeFEgyS8CseAZqU2lKv2Ea32Lw0yrSWeI77ftIe9h65WvxSjuFMVX6
         jP6DucDHg2wuyr4PSeENkiCmjm3wrd+cOA68LgQU5mvtJnm5lKaH79O7rwz2dqRU19YI
         RCJw==
X-Forwarded-Encrypted: i=1; AJvYcCX6UeBCpYi4u1gcnHxkfjWz4Iwiq9Ro0CCWFgJcQ185RweCiCnxu8rDe2rnimXfdUVog82C5elbWnWujXZXvyhsrQtWVcOnNbLEU7V6ZQ==
X-Gm-Message-State: AOJu0YxPLsBXPWc/lWPC7sBTKRwEuJpFlPBhC9zQFbCDPNXnB415oCW1
	qmEM2QeaZ2z4QRBwB7bdo1kpjQjW3KNOeBme4KzP8bL+QWxmnwlvnxR9GF9amN4=
X-Google-Smtp-Source: AGHT+IGPlFGgbB9ZChmhldFXk4lCcGn2QfN58njhIYERbSwnOVMVjITgSghOJBsI4h+oaBy72ES17A==
X-Received: by 2002:a2e:80d5:0:b0:2eb:ea62:179c with SMTP id 38308e7fff4ca-2ec3cffc4f1mr41884141fa.53.1718955116669;
        Fri, 21 Jun 2024 00:31:56 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c7e55db329sm2917460a91.26.2024.06.21.00.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 00:31:55 -0700 (PDT)
Date: Fri, 21 Jun 2024 09:31:45 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Song Liu <song@kernel.org>, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com,
	live-patching@vger.kernel.org
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
Message-ID: <ZnUsYf1-Ue59Fjru@pathway.suse.cz>
References: <20240610013237.92646-1-laoar.shao@gmail.com>
 <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com>
 <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com>

On Tue 2024-06-11 10:46:47, Yafang Shao wrote:
> On Tue, Jun 11, 2024 at 1:19 AM Song Liu <song@kernel.org> wrote:
> >
> > Hi Yafang,
> >
> > On Sun, Jun 9, 2024 at 6:33 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> > >
> > > Add "replace" sysfs attribute to show whether a livepatch supports
> > > atomic replace or not.
> >
> > I am curious about the use case here.
> 
> We will use this flag to check if there're both atomic replace
> livepatch and non atomic replace livepatch running on a single server
> at the same time. That can happen if we install a new non atomic
> replace livepatch to a server which has already applied an atomic
> replace livepatch.
> 
> > AFAICT, the "replace" flag
> > matters _before_ the livepatch is loaded. Once the livepatch is
> > loaded, the "replace" part is already finished. Therefore, I think
> > we really need a way to check the replace flag before loading the
> > .ko file? Maybe in modinfo?
> 
> It will be better if we can check it before loading it. However it
> depends on how we build the livepatch ko, right? Take the
> kpatch-build[0] for example, we have to modify the kpatch-build to add
> support for it but we can't ensure all users will use it to build the
> livepatch.

> [0]. https://github.com/dynup/kpatch

I still do not understand how the sysfs attribute would help here.
It will show the type of the currently used livepatches. But
it won't say what the to-be-installed livepatch would do.

Could you please describe how exactly you would use the information?
What would be the process/algorithm/logic which would prevent a mistake?

Honestly, it sounds like your processes are broken and you try
to fix them on the wrong end.

Allowing to load random livepatches which are built a random way
sounds like a hazard.

It should be possible to load only livepatches which passed some
testing (QA). And the testing (QA) should check if the livepatch
successfully replaced the previous version.

Or do you want to use the sysfs attribute in QA?
So that only livepatches witch "replace" flag set would pass QA?

Best Regards,
Petr

