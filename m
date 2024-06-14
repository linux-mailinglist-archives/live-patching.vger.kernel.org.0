Return-Path: <live-patching+bounces-351-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 32944908C12
	for <lists+live-patching@lfdr.de>; Fri, 14 Jun 2024 14:53:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCFB11F24E07
	for <lists+live-patching@lfdr.de>; Fri, 14 Jun 2024 12:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7AD199E82;
	Fri, 14 Jun 2024 12:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Psl1aZww"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5880F199247
	for <live-patching@vger.kernel.org>; Fri, 14 Jun 2024 12:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718369610; cv=none; b=LPrJDrCXv291dOr/FNheNf3IXnJDZ3Q69FOadJW1U3qKbmD4vTJya73WVaJXFS/EJS1bBlySIhCI08nwVtDOY7U3rpoDdPm5OtHcdeYz/bzYxMe3BBriI4mGb5mYgIGiZtRsQBpDz7M1/r6qa3j5HWXNLg8Q+D/M3Fl7WuuRgXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718369610; c=relaxed/simple;
	bh=IjjAwUBZev5pXBrNN6OXYQrTj6ZG0bm1/jBwSbAoyHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IqYrI9WV/Rlfi4f6jFQ9uuQnEx/qs+316eN15F6JXyI3UcBeQ8sqqN0I7dJix72uWZw9kAwSYiNwPd9GE1PkhWSI6DK+2Vp4n3vMmcY6HNxewQ5YGkYVnoEPfVTFgwv5Uju09nsOHHDJV16Jjxa9kf6EnWSCH1YA4nN2u/1lcIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Psl1aZww; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-57c923e03caso2360478a12.3
        for <live-patching@vger.kernel.org>; Fri, 14 Jun 2024 05:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718369606; x=1718974406; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AoilSNR0Zv9v33itSh5XbUtg3+zoaXog3gNUXdNH/44=;
        b=Psl1aZwwmuIFW/1zL6zAJ3Y6G+Bq9Yhaz2cbFzQe3vqU9hla9djXlNA6VyVIY6rhGt
         XcN9OzuSoEDQHD3n5R+I8ZZwvlmBAazFXgPMAAm5Sa8B26Xb9b/rvhmFvTNjAhG+Mt7N
         MtuM5DY6VpWvcBpbQRmDfupShS72eWGsF8Hz6zQNm9Ved8+a7kx36slyLHQq9TOioRZw
         koSRw9HXsg8sEpbMVAsJJHhobUYoZ/iZwen1PkPELeHSIMRhv3nYTBa15YeDsAhCb6ze
         JM0emCQbVxOOF8+S+CLSz6v5ApvAbicHSU/VsIMBZFr/CpB/51hxx8idw8O8SQqguXCo
         18qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718369607; x=1718974407;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AoilSNR0Zv9v33itSh5XbUtg3+zoaXog3gNUXdNH/44=;
        b=mSXb3SHsaLNS8kTAaX/QZh0ZigB3302jG5Gdsg1PGtVIpk06hc04ONdUPRbAe6eoQ+
         KaLvDNejMVpapZ/zhE6rdD1S3HjqQKipLEJujpYtHzHJNBL2oBot4p9QCFThZmpDuS4s
         eJayOUNTmDxl9j88sxOMAaTMEJmCr5RGGmUzKmiWVHFjuMeLf8qyvoloZrUcVH19LW6B
         JmBmAtwR+5126PlutEyGmta7GZ00B2XBoAbKdzEHQxi1ZSoW+X9k5g68YqNAk+wi4uzG
         bwudMjV+Yu3g1v2UgH0R1ptvBocfoO7Mrl11vx4j/JxoPueoLTmr9MrTILKWPi17SepK
         BFZg==
X-Gm-Message-State: AOJu0YwbGhRND+9ecOQjxbQdTpRfY1aVJE6poRSekBYQtblgyz7SQw7G
	DgtPsmZfTR4f94CS82fbW/nG5c0kMHiLbYfSHji8LzvXPqrd6lq6yEQApP/zEbfmQJhGo9NcLpX
	b
X-Google-Smtp-Source: AGHT+IGUus8CsHftN39O9H3qVE2BWyF8K5O66Ib/Z5sLKQuE1yqYOfnw41+llGSpUsXUjxyHYw7cvQ==
X-Received: by 2002:a17:907:868d:b0:a6f:1285:4950 with SMTP id a640c23a62f3a-a6f60d20434mr184216566b.17.1718369606586;
        Fri, 14 Jun 2024 05:53:26 -0700 (PDT)
Received: from pathway.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56f416dfsm182365366b.164.2024.06.14.05.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 05:53:26 -0700 (PDT)
Date: Fri, 14 Jun 2024 14:53:24 +0200
From: Petr Mladek <pmladek@suse.com>
To: Ryan Sullivan <rysulliv@redhat.com>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, mpdesouza@suse.com,
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, shuah@kernel.org
Subject: Re: [PATCH] selftests/livepatch: define max test-syscall processes
Message-ID: <Zmw9RFNjQjqIR4ro@pathway.suse.cz>
References: <alpine.LSU.2.21.2405311304250.8344@pobox.suse.cz>
 <20240606135348.4708-1-rysulliv@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606135348.4708-1-rysulliv@redhat.com>

On Thu 2024-06-06 09:53:48, Ryan Sullivan wrote:
> Define a maximum allowable number of pids that can be livepatched in
> test-syscall.sh as with extremely large machines the output from a
> large number of processes overflows the dev/kmsg "expect" buffer in
> the "check_result" function and causes a false error.
> 
> Reported-by: CKI Project <cki-project@redhat.com>
> Signed-off-by: Ryan Sullivan <rysulliv@redhat.com>

JFYI, the patch has been committed into livepatching.git,
branch for-6.11.

Best Regards,
Petr

