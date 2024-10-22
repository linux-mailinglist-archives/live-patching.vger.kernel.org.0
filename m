Return-Path: <live-patching+bounces-750-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E969AB1FE
	for <lists+live-patching@lfdr.de>; Tue, 22 Oct 2024 17:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF3041C21AE9
	for <lists+live-patching@lfdr.de>; Tue, 22 Oct 2024 15:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8241A303C;
	Tue, 22 Oct 2024 15:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YonNCLbp"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1FE1A2872
	for <live-patching@vger.kernel.org>; Tue, 22 Oct 2024 15:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729610825; cv=none; b=hywF2UWbqaWo/ChFjfuUQJl7nK6EHA5nOju9fqwJGh6E+93usYU1L1XIC45m5yF7iNvrW1Ft0sOJcZzD7HbC+t5+sqduzj4Z9yDFTaALCd4W2kCuaFFswE/aBnbopr5MhOi12uoseZAp4QOH2FKzv/htJFsBrmNw9XbBiKWPW4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729610825; c=relaxed/simple;
	bh=thVT5OYgYcWBEHUkUQDh5Yr2qH/GQ52rcQpAafIYa+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcknkUOLbwUPrQVQNcxhE9SfqPi5O5o56+Fq+cE2qBVDeu5bhPf121Gj7iaOk1BrxzpsBNp9SuJcGgFZeYQcPuHP4mWU5jW/X7mAWHb4H45E4nt2XflKSSjH8eFXktx8OJa+EvZvA0EBAT4u4DXP6bDOrrr98B1Jmw7FyCTwYaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YonNCLbp; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-37d49a7207cso4170239f8f.0
        for <live-patching@vger.kernel.org>; Tue, 22 Oct 2024 08:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1729610821; x=1730215621; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=24YJn0Eefr1UaXdhDfLXD5n6IqhczycLi2oTef5X5p4=;
        b=YonNCLbp72nLy0jkgOIycNNWRPnDVoNVSJo4IkYaKHo9Hlncq+5HQxqv2fe69xH4xm
         gwZb/NYH/u1SJmo2XzeIIAURO6C8OlFgwVE1ZEmjUXFhuOsGXCngTxTxj8jthXINUPIS
         Ntsv1HQgObgEu7ruIUOHARxuLt4tKlGrWzobu3UZ2twm4NFEBOKKqdpNr5L3WYSvpZEv
         emnxSxFddKojjzRdu1c1d3CXSo8B37755gG8/gOD9/mQk9m/rsESETk5fFT8lzy3Ze8e
         crB0k8n5RkSb5M2t9SHOjuFdWYfgqYIasBw6wtLqqqIUlJSg8ViZ9mRzW05yxXpI7q0b
         trCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729610821; x=1730215621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=24YJn0Eefr1UaXdhDfLXD5n6IqhczycLi2oTef5X5p4=;
        b=pM1fCG3KECUbvOPoCauJbVborTbZKOPzh6Rw3Fj3sFOg7CdXCLzZBBV/Xs5qFPvD6F
         GNxjumJ3ezQ/l0t5mV5+sjukvFx2RX4ad+vAGrVpSrOzSxuqLQXJyvbxOe1UPdDkAKyS
         w2jMh+IYq11qQCJJeIqNRF+3rSVlds0Sgktg1831XnHSR9qLubsUV3dOlbBWRvKwGIvX
         ggXOS+v5r1W/nZD9An5tdU8twZXEj/ewTr/PFx5kIfYcfFSknWqWKJQKehmHPPue7GOg
         frHtGx8QeUc1Ca3Gp9G9pjF3CEby8shOe1ab3sHrjM36huj4lIhv3Tm5LmUSduqBGWqf
         NcEg==
X-Forwarded-Encrypted: i=1; AJvYcCV34153jJ3qihFZstz068sNjVRHNzdx9kVNV9u/47vY20sbhLWP4G6wRMhSEEG17iRmnfwLdJCtm2UrVuS+@vger.kernel.org
X-Gm-Message-State: AOJu0YyWxq4SxEjBIHJ3wIJEKSFXnSJmc6wtbtZ1X/LLxIM8n5FmtIJs
	OSBkDhNmbp+LKXzoT1UhK4onyPD4eLYiKVQDgUTfl0QAKssDOYClHhKJRkiCUgA=
X-Google-Smtp-Source: AGHT+IE3Ze8qPnti7FmguM+/l3eMxeUIvDcJOZvZP6fCGDT29ykg7WRX+lbvHm5hMWtnHpDhwMszbQ==
X-Received: by 2002:adf:facc:0:b0:37d:4dcc:7fb4 with SMTP id ffacd0b85a97d-37ea2137843mr9684480f8f.10.1729610821559;
        Tue, 22 Oct 2024 08:27:01 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0b9bc90sm6807726f8f.100.2024.10.22.08.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 08:27:01 -0700 (PDT)
Date: Tue, 22 Oct 2024 17:26:59 +0200
From: Petr Mladek <pmladek@suse.com>
To: Michael Vetter <mvetter@suse.com>
Cc: linux-kselftest@vger.kernel.org, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] selftests: livepatch: test livepatching a kprobed
 function
Message-ID: <ZxfEQ7WWfcSYfF1y@pathway.suse.cz>
References: <20241017200132.21946-1-mvetter@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017200132.21946-1-mvetter@suse.com>

On Thu 2024-10-17 22:01:29, Michael Vetter wrote:
> Thanks for all the reviews.
> 
> V5:
> Replace /sys/kernel/livepatch also in other/already existing tests.
> Improve commit message of 3rd patch.

JFYI, I have committed the patchset into livepatching.git,
branch for-6.13/selftests-kprobe.

I have fixed the wrong substitution in the 1st patch as suggested by Joe.

Also I have made two substitutions in test-syscall.sh in the 2nd patch
as suggested by Miroslav.

I would personally prefer to do the substitutions of existing paths
in a separate patch (same as Miroslav). But I do not think that
it was worth another respin. It would just increase risk of more
typos. And we have already spent enough time on this ;-)

Best Regards,
Petr

