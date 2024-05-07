Return-Path: <live-patching+bounces-250-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 833268BE23A
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 14:35:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 383AF1F263A9
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 12:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CB0915D5A1;
	Tue,  7 May 2024 12:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fcmKxLe1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A99415ADB8
	for <live-patching@vger.kernel.org>; Tue,  7 May 2024 12:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715085288; cv=none; b=ZlcKxSs8yVJqX/1BYj8zPa0e61l3KA9q0K2WF5rDfeqV94OMLYA9Vfgo2cYj/OE4CNz+U9JG6GOeHFti+RLdXRNcKm3r0CGh6pCl4QnVB2Qyas5zGZXsZ4Mm8T/RV12vFgEMP+y3F8oWSLXQNh1K+E0y00qBAHJY9gasBMGCwWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715085288; c=relaxed/simple;
	bh=4qhhVrDLgvjiR3qGhTOs9uM3suWa+tgK/JAtQej9lNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lo5r9aJCkPP80B6OsHlT3s7HR9+UmhwHiqJEVdTfeIWgM1Sg3ySgZTTXbPeqxBzp7468rpIsB/ysNjxgCq3LQA8NPltsbzBY4rolrOskoZzqdI6Wpf8NbCevXFbmmjpzTtwFoU9HL3+f1GQBajZNtlYlPwSxAu2zrk2jZRnB/d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fcmKxLe1; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-51f29e80800so3373958e87.2
        for <live-patching@vger.kernel.org>; Tue, 07 May 2024 05:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1715085284; x=1715690084; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fb7T1C3RqLm2Zber0tc50ZaqTjghpLq4bIRrAurD6qU=;
        b=fcmKxLe1yEnewMPMZr2Jz5huoki3cxRFB1ASj9i3UrylKgFQeMPskQlJR+HsMozAdA
         BEOxvKgvw/XakEiklmC0WLDdBqVGBRIU/cO3JBIhqpKYBumsSSOJNHCtFpOfoZHpcwlq
         lOBoMxCmgOX8I1brp+fnl7dx8lAwuR8TnNfnTAsUcl9VpOXHMTkVR5/rR1LdaFH6clT2
         HX1RDLlopDkXQkKUSjKYIP7Bngj0S/k0ZXdIiq1sFJr+8kGvE0FLIGln2vPgfjUh2ZSx
         /LRVzyrScZ5gZWX0rkHIhePHs0VSFZp4ZbEVIcWbXelnyTIU3wXB+G445ULtFydRT02S
         o0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715085284; x=1715690084;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fb7T1C3RqLm2Zber0tc50ZaqTjghpLq4bIRrAurD6qU=;
        b=BGxJaXpxCSZNqAvWaBfP+dUTq+d2vL2+oTclRDKqjKYMrpC8ACH3DDLrW0yK9Tjl5s
         4r5erj6tUiJpo9hi5K+M2/uXKNamTUxpmQFNfM4ybF0/xoi04Uss1wQgIYSUr7ZmcT3w
         40I2kNO14R8Wgcax/ovlm1Mdw++PoFwdKDshnv2dRG2gL5/4kuTEk3FBLSqiu/tiwHHU
         yOtANRdPqVrLGNOrAFPN6Jmabfbo7E0QOlCIi3biGg0ERY7fayxgd9gJ/P1XL+uZMyr8
         u4iNVdOA6NXVS+AFHrU0A7likdQAZn2o0g9IZ94jV9Kk1vE4krZ560+9sZI4RtyAy0Gl
         MHEA==
X-Forwarded-Encrypted: i=1; AJvYcCXnc619RalsSiUWE6H2K/rzABnH0aGwaVP6iF/U0sThEXB7CWJbeLHBQ1QPxQWyw/A0NfUBvfKSHQq3etJvkSadUwBD5h6qz0q/vfj0uA==
X-Gm-Message-State: AOJu0YxtSYjxhoy8DOQtu4A3GdcNGBkTInL0RF8kclxktKDq3wCKtNF7
	9SHT4scRnDITOa4gRWSvdVwRrMMUzVAJTyQPRQqfcFHEay16wAMffJNgk+5wkZ8=
X-Google-Smtp-Source: AGHT+IFuuNXxRqEhhogyMFo8s4Muv03vq4OxYhgbMjSC8e3E/QpWVHqtClYBhR+3fXlxPsxYgDYrZg==
X-Received: by 2002:a19:2d51:0:b0:51a:e21c:109c with SMTP id t17-20020a192d51000000b0051ae21c109cmr7768074lft.14.1715085283574;
        Tue, 07 May 2024 05:34:43 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id j15-20020a05600c190f00b0041bf512f85bsm23047532wmq.14.2024.05.07.05.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 05:34:43 -0700 (PDT)
Date: Tue, 7 May 2024 14:34:41 +0200
From: Petr Mladek <pmladek@suse.com>
To: zhangwarden@gmail.com
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] livepatch: Rename KLP_* to KLP_TRANSITION_*
Message-ID: <Zjof4QzDQ2unnjVn@pathway.suse.cz>
References: <20240507050111.38195-1-zhangwarden@gmail.com>
 <20240507050111.38195-2-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507050111.38195-2-zhangwarden@gmail.com>

On Tue 2024-05-07 13:01:11, zhangwarden@gmail.com wrote:
> From: Wardenjohn <zhangwarden@gmail.com>
> 
> The original macros of KLP_* is about the state of the transition.
> Rename macros of KLP_* to KLP_TRANSITION_* to fix the confusing
> description of klp transition state.
> 
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

Looks good to me:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

