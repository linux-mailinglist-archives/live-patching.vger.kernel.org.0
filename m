Return-Path: <live-patching+bounces-676-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 401F59841DE
	for <lists+live-patching@lfdr.de>; Tue, 24 Sep 2024 11:17:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A35C1C22799
	for <lists+live-patching@lfdr.de>; Tue, 24 Sep 2024 09:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3991552ED;
	Tue, 24 Sep 2024 09:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HCVimIaX"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1074D14C581
	for <live-patching@vger.kernel.org>; Tue, 24 Sep 2024 09:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727169468; cv=none; b=bw4FTKOiXtmsj8CBOF2yeeP236Y13LQOorGqb1rVu+pGnoSd+ORJ077rcGdlNr8r43V2/MpdGZNExa/PEzv7fYWUXkY0/IBjgY4WgG3TipgRjCOqAIJrv81oRNJ/K+3Zng3Tz2imIR6DyTGitULqYqq1YnrNTQzNXqmn2yoUyLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727169468; c=relaxed/simple;
	bh=lifwU57IdaHrim70smgz6+zaKKAD/ovA/nD15yWAbWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AYGpVU7elUMyK9krWDIlCNeyg4cEzFqhyR9bzZpmGootYVcpbojiRljlwFsBAXF687CmLSPgNTZ3HttpbENugdNqX0UpTl25zsY5d4RCZ4Josn4mma2tEgSiHL28Twd+QEcDiNB372a6hSzH9TdIvLKYh6CUDZ9AjedpzUCD7KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HCVimIaX; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a8d0d0aea3cso714226966b.3
        for <live-patching@vger.kernel.org>; Tue, 24 Sep 2024 02:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727169464; x=1727774264; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4TJBQey2syq4faSYlPyUUd0DDrhxKWRd+pg4UR04rt8=;
        b=HCVimIaXJWeCpo3bm0SwHyrm7qTpy6sUcLwdDr3lh7ugsJRFkkgfDmUJuh9GYSIwkP
         tAVXqvavXIie0TqmXcA2KMtFpqIkJ31z8obE3GBdDKOG1AfoQLFVX4v3WhO2cHb+7flX
         LZKIHhwnRPJHg2JC7lfPCRqhUbvfRxXckE4DsgPaQsQaWCHDaGJpKtRK6frCr2IKAoKR
         0LHiaZS79l8UK+5rIXo7l5Lz1jw/hv97THGQldDSf42ytRPbf3Ztd3WBabQoylFLA8Sq
         qPpHrPKWTpD5HKIMOi9JEBgwUF+GH+S2LLEhXqsN5gMwVF4R2/0kPpWYGbQkksIqcByt
         QxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727169464; x=1727774264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4TJBQey2syq4faSYlPyUUd0DDrhxKWRd+pg4UR04rt8=;
        b=SBEYxQhjmXbAPF/H/C3/6tFAhMtj4oWYIffIXN9abiYiLhMN66VxLpvjhDIjJ3PWLV
         mjM05QXtCEbEKjlHyHijSvWG6uhghPj17kfG9OKaosVzIZ3iHUOhhbEHcbJpSVXk4Qfr
         ICmZk9NSU1Y31yLs3x1Kp8eFsW3sNhaL5UV7haac8vAc/elX8Ko/Z11cB/KBmOQQEsbD
         0uB7OqRNI19t+BYyQW0k745znE9sJE6TDRzbEqN+GK/1gERbddqyHbR7SLJuv/ry55sq
         jUQvUmN+LSGj3GexRhgRBlgibKS+4amVzdYcxh2jJe2YkGmEQksYugUFg/9pPh4WrwZf
         MMiA==
X-Forwarded-Encrypted: i=1; AJvYcCUPGZasSl/WVTBl7k5IM/0lFbKaz+MDiryIMIIq21jSOuks+zBFrHeBpxTnkc2kYm3Y+y+mkYNKPMlM7SP8@vger.kernel.org
X-Gm-Message-State: AOJu0YzVtVcJb8AYNKYOMU7+L4ZIvVY3O5gwVcLBzp9ULPaMekG6qKnI
	APwLay094v8qANb8z6O+EMXYzk6j8Om4mkvPct0R4WxMxf8pFrf5mngJGEj46zE=
X-Google-Smtp-Source: AGHT+IGsORPtjPRBPeev8eyG/YlXfAlEMN06wNUjYu9/j7siVEu6mX8a+VfIs+U3fjiFWqSttWhs2Q==
X-Received: by 2002:a17:907:d3ce:b0:a8d:60e2:3972 with SMTP id a640c23a62f3a-a90d4ffdd3bmr1314481466b.23.1727169464395;
        Tue, 24 Sep 2024 02:17:44 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93930f0b23sm61486166b.144.2024.09.24.02.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 02:17:43 -0700 (PDT)
Date: Tue, 24 Sep 2024 11:17:42 +0200
From: Petr Mladek <pmladek@suse.com>
To: Michael Vetter <mvetter@suse.com>
Cc: linux-kselftest@vger.kernel.org, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] selftests: livepatch: test livepatching a kprobed
 function
Message-ID: <ZvKDtlu8i5DbTCh4@pathway.suse.cz>
References: <20240920115631.54142-1-mvetter@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240920115631.54142-1-mvetter@suse.com>

On Fri 2024-09-20 13:56:28, Michael Vetter wrote:
> This patchset adds a test for livepatching a kprobed function.
> 
> Michael Vetter (3):
>   selftests: livepatch: rename KLP_SYSFS_DIR to SYSFS_KLP_DIR
>   selftests: livepatch: save and restore kprobe state
>   selftests: livepatch: test livepatching a kprobed function

Looks good. For the entire patchset:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

