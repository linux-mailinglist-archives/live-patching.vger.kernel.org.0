Return-Path: <live-patching+bounces-382-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E759272A1
	for <lists+live-patching@lfdr.de>; Thu,  4 Jul 2024 11:02:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F0D428D141
	for <lists+live-patching@lfdr.de>; Thu,  4 Jul 2024 09:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C6B18FC81;
	Thu,  4 Jul 2024 09:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bUt0k7LD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC381C68D
	for <live-patching@vger.kernel.org>; Thu,  4 Jul 2024 09:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720083770; cv=none; b=p0F0aOKVYOfnfcmGZlKVQ2R0MpTq5whnDaqymnbPGdpx4GH90xVEXWfboaJFWNch/5rCX57ug8N/B3+LioMLs3bvGJE45Heq84Td87J+8Fzll8NrNV+tafxkui3cFIgXI34D1gOcisQFxjezoi8++mAGw4d/7n/lkSeXrTo7PVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720083770; c=relaxed/simple;
	bh=G7CO/CL4pp10TGPHFmXkvkXMIw9hPunx57cDry4uoXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J8uniFMpWMuk4/pXng5H+p8MlrJqEJayTvDLZVO1jj2Ialtqk23O1I2NpbjYTIBgerRE6fOVhwBLzfziAI+V+NztoQKjtA5cFFBVZ+tnk9q3m+0a2VR17TZVex+vrXzYYH1qivKxCPNdjFHIV+6HK6sYRkOZVcxwKF+McFfjeMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bUt0k7LD; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ec1ac1aed2so4042961fa.3
        for <live-patching@vger.kernel.org>; Thu, 04 Jul 2024 02:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720083766; x=1720688566; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YmTXwmh1YVZIuuasStO2QRvsBLiKm7EOJYEtTyW4F4U=;
        b=bUt0k7LD9XjnjcO83BPS4KJ4BJoDrtxzFXHwyRrSQpD0ACDQxVrUdnwqSpv1mHz3ng
         75j4obTN3HoEQMCFaZB4nx1BDh+HILYN9gB7tt7gHBNI1UK3FfCN/uUKPSn/DZO/YKHY
         HIuPt88pXY1UIaePwn0tw6/uWSv9MJ/VTPviNmxt+7piRcUpZW8SY4cY23iamujJlBaR
         rb/54yKW7UX3+ZJeArkTrFEZWKqMyrCZAfoF+GjCZ5xkEuPEaTuIOasc6IYxh0nMO4/d
         RowNrxILPc/h7Yq6t7XxmpS8bTZlACy8IJlu00NIGPYiiExK9NFSsmso2O5/Vtsmotk1
         JceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720083766; x=1720688566;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YmTXwmh1YVZIuuasStO2QRvsBLiKm7EOJYEtTyW4F4U=;
        b=meDIgsDwhQ94OPxbcBVLpAVr1eCUaiJCYCnZW79d/8f32ct21XfsRn7ZMh9A/nyXV8
         cRDodF39YWL/Gm/79pCDgQWIZK2l4cMbxQE7d/NvPEj3gEE1P5lbiafwO/x/UplPSyR5
         GhdrBOQvi6v+n/Akkd5XEvTKm28DQJnMk3QAcH5ZCfWJcNbc0JFPiLBcyvcrg5w7UqmO
         pgU45IeTnPuhmXD3oKrHQHaAYtqDdLAbl2bsgcNAC999MUyBusNHI6Z/UVZPqktSBjlh
         hdR1lvlTaVl5vte6+ubWJxvUINQ2rmSeEhEsaVNpIYC2t0G/2XmOyZ987xp26aULSKad
         HwVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWb2/mU9HTcnF8KD9VFmtmXppR0tXQ8rdUqDWXI+RiEwhkOvnx3CsB16Ms2h42NEvI/A2o3iExL2dTFF8WLY8U3vVbGXQ8CS6OGiLvV4g==
X-Gm-Message-State: AOJu0YyrYz7eiVMpWGInx3hKKq2q2y+TG4bC/FhhnVJhoiQCImbjuxVM
	z5cObylqmV1RF+9gGSipGOPkNb/91ZxYsb1qmdLKraf+Xl2z0/W43By+qhFwiBY=
X-Google-Smtp-Source: AGHT+IGBdC/+ZkuCypIRlFRUUAawwwMvrs2VcrlAwPmzy3O+A1bo954nfyMjIo5nhBQhpQhi5s4SVQ==
X-Received: by 2002:a2e:8007:0:b0:2ee:7e6c:34d6 with SMTP id 38308e7fff4ca-2ee8edf14a9mr7759961fa.53.1720083749350;
        Thu, 04 Jul 2024 02:02:29 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fb3ce7144esm3116645ad.300.2024.07.04.02.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 02:02:28 -0700 (PDT)
Date: Thu, 4 Jul 2024 11:02:18 +0200
From: Petr Mladek <pmladek@suse.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Sami Tolvanen <samitolvanen@google.com>, Song Liu <song@kernel.org>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	jikos@kernel.org, joe.lawrence@redhat.com, nathan@kernel.org,
	morbo@google.com, justinstitt@google.com,
	thunder.leizhen@huawei.com, kees@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
Message-ID: <ZoZlGnVDzVONxUDs@pathway.suse.cz>
References: <20240605032120.3179157-1-song@kernel.org>
 <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz>
 <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
 <alpine.LSU.2.21.2406281420590.15826@pobox.suse.cz>
 <Zn70rQE1HkJ_2h6r@bombadil.infradead.org>
 <ZoKrWU7Gif-7M4vL@pathway.suse.cz>
 <20240703055641.7iugqt6it6pi2xy7@treble>
 <ZoVumd-b4CaRu5nW@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoVumd-b4CaRu5nW@bombadil.infradead.org>

On Wed 2024-07-03 08:30:33, Luis Chamberlain wrote:
> On Tue, Jul 02, 2024 at 10:56:41PM -0700, Josh Poimboeuf wrote:
> > On Mon, Jul 01, 2024 at 03:13:23PM +0200, Petr Mladek wrote:
> > > So, you suggest to search the symbols by a hash. Do I get it correctly?
> 
> I meant, that in the Rust world the symbols go over the allowed limit,
> and so an alternative for them is to just use a hash. What I'm
> suggesting is for a new kconfig option where that world is the
> new one, so that they have to also do the proper userspace tooling
> for it. Without that, I don't see it as properly tested or scalable.
> And if we're gonna have that option for Rust for modules, then it begs
> the question if this can be used by other users.

I am still not sure at which level the symbol names would get hashed ;-)

The symbols names are used in many situations, e.g. backtraces,
crashdump, objdump, nm, gdb, tracing, livepatching, kprobes, ...

Would kallsyms provide some translation table between the usual
"long" symbol name and a hash?

Would it allows to search the symbols both ways?


I am a bit scared because using hashed symbol names in backtraces, gdb,
... would be a nightmare. Hashes are not human readable and
they would complicate the life a lot. And using different names
in different interfaces would complicate the life either.

Best Regards,
Petr

