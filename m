Return-Path: <live-patching+bounces-282-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 72B948CA994
	for <lists+live-patching@lfdr.de>; Tue, 21 May 2024 10:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC8EBB22870
	for <lists+live-patching@lfdr.de>; Tue, 21 May 2024 08:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C714D9EA;
	Tue, 21 May 2024 08:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VMXUX7R6"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E366A4CE04
	for <live-patching@vger.kernel.org>; Tue, 21 May 2024 08:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716278682; cv=none; b=EtDXJ5Cj0vj56YANccHSE5G4jn4PV6gIzz7Yb5bIci45MWDxTBHuO2eD72onGU+Mah2KLSI0RU6bXHNdJvp+YDQzUug11yrfUJUE8rbikpnbuCk8mraFwILm8NLZS+k+Q1c7yeUbsV1OsWOqC4NkelvB+j8n1ntIm0tient9qYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716278682; c=relaxed/simple;
	bh=H1pX/l/9zFJBqeC65WLx5xVkJ5/5BEYFzpClMZLFUWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCXE2lzU6LJZIY8lY4n/Q986V/CxJ8K8LDzUZS19yWKqq0MsJYQl5RHJscmbohH/jEkg9XURlMIaNM4R84DI/yvvhk6Te0BLUH+IKgZKr4hoLuQNy3//4y8zxaHgCCeYXFgN8xrgOinykgZu0GjG7V7ANmGTlCuedXLlQjfRhK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VMXUX7R6; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a5dcb5a0db4so324824166b.2
        for <live-patching@vger.kernel.org>; Tue, 21 May 2024 01:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1716278678; x=1716883478; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=L8zfwXAqu2uLm4XXNzPsYjNVm1x+e8a1p9Cw49ZRtk0=;
        b=VMXUX7R6VP485JSuJUXNjJnN2RNrZCkXIUp69JKAmC2CjCIKXba1LS+EEFFGU3dU0p
         on8P1XDa9vRgTHYwtR/4AtzaH7/u04BtpjCtzZPpFFtEKutxwBn1y1M8AmE/wZ5qE5p/
         pQtc09yjbDUA1Nqozmb4VPKeWR3ub8vo2P6ddITeMmsEfZjnyS0tQOWrhCEzXxfmxb9U
         /RYBJNyvrv6UqQmT8rfUJBc9jueMFgmOkZP5ZgOTZVML3HwifRlG8bBRUKiqM/04DirF
         zP5PdZFaHbmFVsO4dPYF2V+T+QtB4C18b7j7av7BPS337sQaDjLotnWdK4A3YXsvhgWz
         oQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716278678; x=1716883478;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L8zfwXAqu2uLm4XXNzPsYjNVm1x+e8a1p9Cw49ZRtk0=;
        b=UHAv857Evl2KACtzl/k+lyUO/gnvlhpJoKBEb8Bk9pnovIi7YYf+9p0Nwwc3JuLsS/
         7KCaSG2iBpYK6MzARopDtls5vYyEKTX+EflS+LqO69ausqTPmzCfpmFFmU4zQ2afealW
         1e/adMCoJ3QP8Bm38vr1ne9koFcMGLEGB8QMZ4YRxOP49BuVrI7OYC9nuYcmI3KuE3Db
         lTuiLr4C4xpYHtSc961RWBIC3iMl9hJBL+bil539CoHtikWiApUQcA8m/yd1lCL/VSX/
         5E6HWdw+SrZ7WbZu4K/NzF5icHtULFhpzGfUaMb7NQeLVnuYW0UyFXS3vOqQMMVUl8iw
         0W+w==
X-Forwarded-Encrypted: i=1; AJvYcCVfSm584Fc5eEWBOw8+603qf9x+xsKe4vICYGkJJYEPZAxSVUGjbMzA3wiv8St4QgMXGCCyzCxy62YHr2NUsPTAgn9T0swkjX5IJyOYhw==
X-Gm-Message-State: AOJu0YzJkDjv0GG9NXYRaltAGtGFPJWTFPqJ4P7HN6nKj23n9KHlySbn
	CwnWSgcGkszyttcDgWzFt6ft3M/VF8IcMZwwgvu9fanT6v16NdFcWM6Q51WAlew=
X-Google-Smtp-Source: AGHT+IEwSwaoGXszRy/vlwCN9/gMLqSB6q4698CsQ2KEnbnUuauXnQjOqMjiZnb5tAm0Wcz3tAFUHA==
X-Received: by 2002:a17:906:3184:b0:a5a:1579:9033 with SMTP id a640c23a62f3a-a5a2d53abacmr1834565866b.1.1716278678198;
        Tue, 21 May 2024 01:04:38 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5ce048529asm708154266b.222.2024.05.21.01.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 01:04:37 -0700 (PDT)
Date: Tue, 21 May 2024 10:04:36 +0200
From: Petr Mladek <pmladek@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: zhang warden <zhangwarden@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
Message-ID: <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>

On Tue 2024-05-21 08:34:46, Miroslav Benes wrote:
> Hello,
> 
> On Mon, 20 May 2024, zhang warden wrote:
> 
> > 
> > 
> > > On May 20, 2024, at 14:46, Miroslav Benes <mbenes@suse.cz> wrote:
> > > 
> > > Hi,
> > > 
> > > On Mon, 20 May 2024, Wardenjohn wrote:
> > > 
> > >> Livepatch module usually used to modify kernel functions.
> > >> If the patched function have bug, it may cause serious result
> > >> such as kernel crash.
> > >> 
> > >> This is a kobject attribute of klp_func. Sysfs interface named
> > >> "called" is introduced to livepatch which will be set as true
> > >> if the patched function is called.
> > >> 
> > >> /sys/kernel/livepatch/<patch>/<object>/<function,sympos>/called
> > >> 
> > >> This value "called" is quite necessary for kernel stability
> > >> assurance for livepatching module of a running system.
> > >> Testing process is important before a livepatch module apply to
> > >> a production system. With this interface, testing process can
> > >> easily find out which function is successfully called.
> > >> Any testing process can make sure they have successfully cover
> > >> all the patched function that changed with the help of this interface.
> > > 
> > > Even easier is to use the existing tracing infrastructure in the kernel 
> > > (ftrace for example) to track the new function. You can obtain much more 
> > > information with that than the new attribute provides.
> > > 
> > > Regards,
> > > Miroslav
> > Hi Miroslav
> > 
> > First, in most cases, testing process is should be automated, which make 
> > using existing tracing infrastructure inconvenient.
> 
> could you elaborate, please? We use ftrace exactly for this purpose and 
> our testing process is also more or less automated.
> 
> > Second, livepatch is 
> > already use ftrace for functional replacement, I don’t think it is a 
> > good choice of using kernel tracing tool to trace a patched function.
> 
> Why?
> 
> > At last, this attribute can be thought of as a state of a livepatch 
> > function. It is a state, like the "patched" "transition" state of a 
> > klp_patch.  Adding this state will not break the state consistency of 
> > livepatch.
> 
> Yes, but the information you get is limited compared to what is available 
> now. You would obtain the information that a patched function was called 
> but ftrace could also give you the context and more.

Another motivation to use ftrace for testing is that it does not
affect the performance in production.

We should keep klp_ftrace_handler() as fast as possible so that we
could livepatch also performance sensitive functions.

Best Regards,
Petr

