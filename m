Return-Path: <live-patching+bounces-466-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4787094BA03
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 11:49:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD7F11F22374
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 09:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA3C718A6A8;
	Thu,  8 Aug 2024 09:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ORTtui13"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FBD189908
	for <live-patching@vger.kernel.org>; Thu,  8 Aug 2024 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723110519; cv=none; b=Hd77Chu6UQnJRM3zrjrrvgOA7utcjfZrvOT8tozUQxWFRjU9s37gakeNEmkzJYzYo7yTz5LsbWWRJyvvGZ2EwtLH+FRFFIS0Qckod9XcScT9c1DFpqYuGXLHg+nL7AFsiwL+lz9OCSU7ax0W5n8zTqSO1ygBGhdly9oIy7s5SSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723110519; c=relaxed/simple;
	bh=bl3bOi05m/h7JLmHIwyve6X2Hujnul+rZJ1BQOQv/5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eljfM+78XatxmzOHHDmmh+4muxXYh2DM7WI4nX23GBjYSn6mTvZpNHRTi7m+MkC80esh6VrCE3fSIlBdEG7mpKSrBcs3T5wxxCivm0cetu5GUl2SSiiBKH6KseqY8ATlP++QMBJVmhaEJoG9wcgy38AE8dqUD8r5A1OTKmX91uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ORTtui13; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a7a843bef98so77211366b.2
        for <live-patching@vger.kernel.org>; Thu, 08 Aug 2024 02:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723110516; x=1723715316; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UP7WYb2s6W/huDcH8KCmTjaOFF/lSa6GQFZ21g6l3D8=;
        b=ORTtui135wiYry1wFosyPqxrXggzAsDeAKJeYcKg/jN4IGd/MylNaWu4g9gPsXt2O3
         Zcglx70KwWYmvkVhw+Lv+bDW7VuRSz1v51DstSwIh1vSHj984Kt+OsRVyJX1pC2Klvf+
         5FAyV9FK7qbyYHzqSA55DPhJ3SfyA4+VNUACtPuU3f76D4ScxTXTOky031hVZCrrYPpM
         YlI2z/O6SLxHCOlIqyB29/WPdPrNMQ2v37rmrPgL0bLXbqb4cU1CXCdY3YT16dK+TKPl
         JeKsBsezLLvZIevuTVTKDxwoCkPELu92Rox5uknpNJOrN6BuFsAIHOgnPRV0Xe3bNQ6k
         uGLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723110516; x=1723715316;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UP7WYb2s6W/huDcH8KCmTjaOFF/lSa6GQFZ21g6l3D8=;
        b=XFmun4NhXj07qsWskSQ7qdJJrCEZzJ4pBKEBYoBD+D+dj4rhpj29jZV9k5krN4HDyC
         IGBiLeylLetX5ea5yVJbJzZ4lWChyuX5A2m8OjGhBGA/yU4nH3gw44BAlc4IPi4EfvIk
         5S8Bo5ZHji3Evqa1N1ZmSpJ9pQdP5Gf71e60cDeq3RsVx2YWoi02xalgHkuWKKjGRnM7
         9cOalcCbxlqbEYVVdSxElCl23aUwuQhWRdjJ+LmTms8teyF+ezoHh8mWZf1S+UC+D2Rm
         AToE3AAdXN9mWAZnYUPeZArSDNrTKA7JCwrBpHri+Kc8H5vl4EAPRAzNHye1tkqz1+fP
         eKlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCyRqgQ9s3uOtzNKcNoTh6f0xwtQpDHw1Ww5LGZbAuJo2t/Fum8R2H043fdNrxvN/9JflCj/IA81tqC0LgYf9PbwXDUjHsaNRXX0KfKw==
X-Gm-Message-State: AOJu0YzJYat7YgbS4KVdb4FFquCzrUj2sHdJ4MnDcNRJOIm0FJ270NHq
	tHHOLeLmNYUlvU3Mz6KIxCXE8yce+59M8D/O/5zASeZ9DIIcRABFDaaHtzVDlF8=
X-Google-Smtp-Source: AGHT+IFixvHVqElBCp/LQrILvS+YLJTdWswh0h0/ODW6H+h6Way2eP9DERfLit0CUsvaDC6vb4y/lA==
X-Received: by 2002:a17:906:f59f:b0:a7a:bae8:f299 with SMTP id a640c23a62f3a-a8090e3d151mr108104266b.51.1723110515536;
        Thu, 08 Aug 2024 02:48:35 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9d426e6sm718153366b.122.2024.08.08.02.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 02:48:35 -0700 (PDT)
Date: Thu, 8 Aug 2024 11:48:33 +0200
From: Petr Mladek <pmladek@suse.com>
To: Song Liu <songliubraving@meta.com>
Cc: zhang warden <zhangwarden@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>, Song Liu <song@kernel.org>,
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	"morbo@google.com" <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Leizhen <thunder.leizhen@huawei.com>,
	"kees@kernel.org" <kees@kernel.org>,
	Kernel Team <kernel-team@meta.com>,
	Matthew Maurer <mmaurer@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Message-ID: <ZrSUcbOtNc18D8ax@pathway.suse.cz>
References: <20240802210836.2210140-1-song@kernel.org>
 <20240802210836.2210140-4-song@kernel.org>
 <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <87F7024C-9049-4573-829B-79261FC87984@gmail.com>
 <22D3CE6E-945B-43C4-A3A2-C57588B12BD0@fb.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22D3CE6E-945B-43C4-A3A2-C57588B12BD0@fb.com>

On Wed 2024-08-07 19:46:31, Song Liu wrote:
> 
> 
> > On Aug 7, 2024, at 7:58 AM, zhang warden <zhangwarden@gmail.com> wrote:
> > 
> > 
> >> In my GCC built, we have suffixes like ".constprop.0", ".part.0", ".isra.0", 
> >> and ".isra.0.cold".
> > 
> > A fresher's eye, I met sometime when try to build a livepatch module and found some mistake caused by ".constprop.0" ".part.0" which is generated by GCC.
> > 
> > These section with such suffixes is special and sometime the symbol st_value is quite different. What is these kind of section (or symbol) use for?
> 
> 
> IIUC, constprop means const propagation. For example, function 
> "foo(int a, int b)" that is called as "foo(a, 10)" will be come 
> "foo(int a)" with a hard-coded b = 10 inside. 
> 
> .part.0 is part of the function, as the other part is inlined in 
> the caller. 

Hmm, we should not remove the suffixes like .constprop*, .part*,
.isra*. They implement a special optimized variant of the function.
It is not longer the original full-featured one.

This is a difference against adding a suffix for a static function.
Such a symbol implements the original full-featured function.

Best Regards,
Petr

