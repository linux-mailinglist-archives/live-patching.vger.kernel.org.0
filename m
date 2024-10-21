Return-Path: <live-patching+bounces-741-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57BC39A72AB
	for <lists+live-patching@lfdr.de>; Mon, 21 Oct 2024 20:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 840881C224D8
	for <lists+live-patching@lfdr.de>; Mon, 21 Oct 2024 18:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 860241FB3E0;
	Mon, 21 Oct 2024 18:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B5LcRR2R"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9017D1FB3C4
	for <live-patching@vger.kernel.org>; Mon, 21 Oct 2024 18:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729536951; cv=none; b=sVnyvcVGTNQklYuImoC/oJz4lYf7Hm11nskr9l57wB8a0h4dcWCWBQ8UJX+NLa5zKx/TGY7eq78vWN3SRVl/IgcJrON3dX9HszYB0Wi6IHXlaFED3Y869VOU7uV8w0mkXy748ZTZYJwdFXVyCR300VRwfjpmKLkKHpq/UqX0+JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729536951; c=relaxed/simple;
	bh=P94yeCZ1yUprg6wEzxiZ9AkuF/1MTkg1vdVbCLsHZ0k=;
	h=Message-ID:Date:MIME-Version:To:References:From:Subject:
	 In-Reply-To:Content-Type; b=BWEjZfhol9NsLXIPLeamRbounCV9MhBQpJPwPks8bvAoLx86PNR0njj4OJ8Hdxtr1XvzN7rF43ry1gmNeAK9gbFhWkEQVl+Cv7MFmqfTjse1A9Lv72mjAkBVbsIwwWdfvIXIUUZUNbVCCPMvktPtSr35ENHD++NhDpGSC3cXpXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B5LcRR2R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729536948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XBkJ6hUVM4B8eeUJkxTpyoBu12NtgYMeTdK6LmP0Sx4=;
	b=B5LcRR2RrlE2C7ogZmzACH/UrZo9fH3WPy40GyB1Qmx9q/gfF1C8Tl7pFJSNwNZGMkW8+E
	0owAMNXJLI/wae7kI+ZXfKLBilwHo1YaKE72m4a01NtVmjDA0i6kyjBgqkFeR4TpQI6wWu
	Bp30LuzifY178TiGqbEfd4DZJAGGiz8=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-P_3GynA0ORmOHcHPKC_3qg-1; Mon, 21 Oct 2024 14:55:47 -0400
X-MC-Unique: P_3GynA0ORmOHcHPKC_3qg-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-84ffd8ea8a8so811887241.2
        for <live-patching@vger.kernel.org>; Mon, 21 Oct 2024 11:55:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729536945; x=1730141745;
        h=content-transfer-encoding:in-reply-to:subject:from:references:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XBkJ6hUVM4B8eeUJkxTpyoBu12NtgYMeTdK6LmP0Sx4=;
        b=lesCtBqbSGpps7QUKkTzJ/vM3icgjswL8jHhDbNkOcmrBADZlcbvcO2mLG5tvlQP0Z
         wlFoJlUH7NeOcMMHVsyKs9rz/bRWu5xk7jsDwfcCnMJLEelAAiLiWMzSYHmG/cmKMrtE
         tj/v2htXt793ZEgG92PsHdQ2mmVn56RtSrlcgzdWByq/mj6mWmOyXOTCzvC0XflSSyk9
         R/zSiQl59zx6NwFFvP1BnaNu7Cr6cTwjm86ejPaFpvn4OTHmQFg8OC0E1KZnmlQ8kjH9
         x4ef45WtqQMA52QpiRGpKyAnGH3P1k6CHyNc8GAcF9ZfLV3IyZt1QOjnxA8n+y5nLSrQ
         03Fg==
X-Forwarded-Encrypted: i=1; AJvYcCVBynw3bRJlUE4vicTxgdRSE2A+z4ovdE24EDLRh+sriQWeZwAZnPhzanN8KHrQqEd0BHztk1G0QzEsQA/h@vger.kernel.org
X-Gm-Message-State: AOJu0YxAFazO1oM8fs6T0LbTVVULfdRB6DQ+ffZwTtfM2NmfB+lqIwdb
	SpV1+IyMI7ev/gglRWn4eLNlSJ7t2B0gg2AVKpM9/P4QWvmwEG5jSoftSmamqvUnh325zDbb34M
	sX3OuVTidNxkrjRaqf4iFT5AAINMRvuM9CaVmZP0ZhC70uC2R5aC2inVjiA1hKEUJHQhp1ZE=
X-Received: by 2002:a05:6102:38cb:b0:4a3:c516:3173 with SMTP id ada2fe7eead31-4a5d6ae510bmr9645983137.12.1729536945683;
        Mon, 21 Oct 2024 11:55:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFidBydUUsOgzIfYFVhv13IqsAmtwVFb+t47/0xhYXC+BA6NbCa2gpPvYQ9JU6flUBkSbmWjA==
X-Received: by 2002:a05:6102:38cb:b0:4a3:c516:3173 with SMTP id ada2fe7eead31-4a5d6ae510bmr9645967137.12.1729536945375;
        Mon, 21 Oct 2024 11:55:45 -0700 (PDT)
Received: from [192.168.1.18] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-460d3c6398bsm20764881cf.30.2024.10.21.11.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 11:55:44 -0700 (PDT)
Message-ID: <da00cde9-ca61-266d-2185-7664c1bade68@redhat.com>
Date: Mon, 21 Oct 2024 14:55:43 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Michael Vetter <mvetter@suse.com>, linux-kselftest@vger.kernel.org,
 live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241017200132.21946-1-mvetter@suse.com>
 <20241017200132.21946-2-mvetter@suse.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v5 1/3] selftests: livepatch: rename KLP_SYSFS_DIR to
 SYSFS_KLP_DIR
In-Reply-To: <20241017200132.21946-2-mvetter@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/17/24 16:01, Michael Vetter wrote:
> @@ -246,12 +246,12 @@ function unload_lp() {
>  function disable_lp() {
>  	local mod="$1"
>  
> -	log "% echo 0 > /sys/kernel/livepatch/$mod/enabled"
> -	echo 0 > /sys/kernel/livepatch/"$mod"/enabled
> +	log "% echo 0 > $SYSFS_KLP_DIR/$mod/enabled"
> +	echo 0 > "$SYSFS_KLP_DIR"/mod"/enabled

Nit: syntax error here, should be (quotation fix and $mod is a variable):

  echo 0 > "$SYSFS_KLP_DIR/$mod/enabled"

With that, the test works for me.

-- 
Joe


