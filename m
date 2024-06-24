Return-Path: <live-patching+bounces-363-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43418914F1B
	for <lists+live-patching@lfdr.de>; Mon, 24 Jun 2024 15:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2BC8282A78
	for <lists+live-patching@lfdr.de>; Mon, 24 Jun 2024 13:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7864513F442;
	Mon, 24 Jun 2024 13:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LmkZxRwj"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E40813E04D
	for <live-patching@vger.kernel.org>; Mon, 24 Jun 2024 13:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719237019; cv=none; b=UtrlwY3wgK7VDWN4AZu7jneaf+aW+SUTfD1X2TrrDaLDS2SKH5WckoBBMnrxGO+supP4hTZtE9A42NA7lncl9G5Rr7180gjvgMYTvlyKaGH1depB4v58HYWltsk3Qf5OKuDoe5e1pIuBjV5/rZMlkYOdp0A69BmQQopZKyEfuts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719237019; c=relaxed/simple;
	bh=sQGhBGVTMSSw5DplF1A/6O1kxjk4IUTHE4cJDGXmuNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kVCNDZf47pwGcB8XR3EFx0VLAzIMj0t329n1maMWv4hnDNuB7HqIVzEs0s98uzHqsSajuD3syFpjwLhD26lX9MIiHOVtUjGuwX/7bK+IhZCho4kYuLu/zsTG5OqG3vXL9pLWFKL29J7sMZ89lXhpvK2Nu3KAry1p6P5KNFoBqmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LmkZxRwj; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3621ac606e1so3188016f8f.1
        for <live-patching@vger.kernel.org>; Mon, 24 Jun 2024 06:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719237016; x=1719841816; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wHB757T3u2N2BMHcnBCzcrR5ASFvYfUpFsIZ/Zw+QiI=;
        b=LmkZxRwjwho6vWIh2lTv6Yp4ZMfVgWqqbYVPaw4trOTuINpZE/OYGvDM34rd/fMBk/
         F1S/M6fi7b52KuzYjEsx0YqaBy18ASKIYIS2d6TO+bmjzeIRum4zhtu4wN6uF93zHOj6
         vV1nIY9oyStPDQ08C2rqtaHdnd3EW2Fj2XPmPUMLHFJuEPReaX3GpiwyMea4K/mSrIee
         t1r/nGwypluBu5KniGFbg5VXtriMLC1r+oa01MfpTiq1kmaIKj6M2RddVsdJCt7xlaWa
         Jf5s+JxbACQf2UzbqZf72wLI2CBfuYHUyNnEu8ZX71TtJwLGRPOIPsZ3fRZw31FjQT+Z
         KX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719237016; x=1719841816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHB757T3u2N2BMHcnBCzcrR5ASFvYfUpFsIZ/Zw+QiI=;
        b=b/uKQGThd/IuQI5sfjH9OiSZZDW7kSAv/KqYE7YKj7Lrp/wA1tfjXIwt45o9NDGt61
         JTxHIYRz8mCbZVPpMZFe6W2fWo3gEa7uFudvRr5u5S+X0nOq7zbcAid0OM+1pL454wzy
         7hrdEv8dtYYNmteo0ZitzI4Gj6xXyJ7x+Wj8geTpHkpPTGBLzw4wsIZylJsNWgKzyTRh
         dyx88D4FnOXoV5cJ951yHS8Hp6ouScYjXk3x8V0z0qUZ0rtZN5WTDPlmUzH2+YNSWePQ
         uOE7pNmGWTQeIvE8jyblucx+WTCwigIFwtNI6ZaTeMnO9ayCPhifTnPqK3sHkudVK9tE
         dT7w==
X-Forwarded-Encrypted: i=1; AJvYcCXNUI7vWlif93ipwEz1t+br2O6wXCKcXurv02X9IUCwe4FGIlR72tUBXicvtFSAh5SkxB0patkB2f3KYd5dr8g6uGcxk8D2uEmtm5Sd8Q==
X-Gm-Message-State: AOJu0Ywxosd4rtKvYmyGoAniB6V+3uJ0xcOIBCioWxm1Usg/OTu9b1tF
	+NvYHV2gAeMnJ55hc+ZPSMRmzksL4e1D5wOeYzF1zNool/TjvS/71EsNFVrv93A=
X-Google-Smtp-Source: AGHT+IEgjk6+AgGh7PEmxoSbBiA8h32QMRrnELbdY7DRi0svMcp0sDDGVhDF0yonWb0Oexi3xl0p+Q==
X-Received: by 2002:a05:6000:1a54:b0:362:b906:11f2 with SMTP id ffacd0b85a97d-366e3337f42mr4308368f8f.34.1719237015740;
        Mon, 24 Jun 2024 06:50:15 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb326397sm62759585ad.106.2024.06.24.06.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 06:50:15 -0700 (PDT)
Date: Mon, 24 Jun 2024 15:50:07 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH v2 3/3] livepatch: Replace snprintf() with sysfs_emit()
Message-ID: <Znl5jw_lrzuaQpLP@pathway.suse.cz>
References: <20240610013237.92646-1-laoar.shao@gmail.com>
 <20240610013237.92646-4-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610013237.92646-4-laoar.shao@gmail.com>

On Mon 2024-06-10 09:32:37, Yafang Shao wrote:
> Let's use sysfs_emit() instead of snprintf().
> 
> Suggested-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

