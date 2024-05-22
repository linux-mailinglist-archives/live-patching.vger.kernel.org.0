Return-Path: <live-patching+bounces-283-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F2C8CBEF0
	for <lists+live-patching@lfdr.de>; Wed, 22 May 2024 12:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 122A6281F34
	for <lists+live-patching@lfdr.de>; Wed, 22 May 2024 10:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ECC98172A;
	Wed, 22 May 2024 10:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SMlrFHX+"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404B67E572
	for <live-patching@vger.kernel.org>; Wed, 22 May 2024 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716372332; cv=none; b=pwuO4HA7jq6e/uBPLtbHIYiFhtOTb08qDGN1tcopbtGL0LNbog3ZXMmsN8vDr2Y0d1AZMXVjvAeNBRKyiOJQ0swF/NPvWjDAqmkq4UlzlIHSqZAhj5QU/7ZSvyHFqIi4zEDq1FqLSStGrt+06jJpNxc9SUQXZDy82uRI1oNsRLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716372332; c=relaxed/simple;
	bh=FzxcMdJRlw32pxc5qidtepX6vG4x8QIo99LwzafuDe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qyXSOLUBEv7b8Kt+pccVoL1ehV/nZc/yeS3bsfOWXFVCwXpoacyOwqTjWe3Ni5n3JoTbI020crkrMXhrXqmfzNYLnOs/Ebfm5UAERjM6/F6V17jfpNgjaCVMeDNKiDIroMtIW6MR+WggiJcXm5xLtCoS4ifwCxjLWUQ/VEskPY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SMlrFHX+; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-56e1f3462caso10473459a12.3
        for <live-patching@vger.kernel.org>; Wed, 22 May 2024 03:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1716372328; x=1716977128; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MAuT1CrGzLDbQfX5xdrNBQ8TlS884bMDX3/yN0VN0vA=;
        b=SMlrFHX+KM9srHdfMMlhuHmyVbhrXRm0NMAA7qKQQcLew3iv8fbZJLCDabJbxp6rt6
         AorBN1yGYLGpnqu7WAlmupYr8nMAALqQX3foi8xkwHImGtnLxCvhddTTMte1wmlgPHga
         DIFUvzTCzbfxtG8DBtGprtvU3oSIlI/mrSJZgJGOV8hEAAjeuhXN2771dt+92G9EXE4e
         gtgQwbvOnNkLto+jbgsL59mgAclpCU0/OpfTEgIB8UAY/uC2/xvxARg/yQo7wrh/cwn8
         J3Hq4eXZnSaEqmU41McMhLhVQWbirFtWOzSjiYWPtRvOoZ4nGUXSV96Ft0uQHcQXtzxs
         qHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716372328; x=1716977128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAuT1CrGzLDbQfX5xdrNBQ8TlS884bMDX3/yN0VN0vA=;
        b=juVu6EwOAdI2zHLKmb5nXP7ezF5kWQl+HftJQeDdJTdTgqqRBtrR+OQGxT2bAyY/tO
         RQ3a2iiRgTeCoJk9Qlcl0RCZQULXAr15vhz+H+VIgjc8kpkpPBrf7XDvuWkU9zAGY8vo
         CyWH3UhrX1gD0xRUJ6Uz8oo0slHU0OsRVM31c4L5FlV5FOjp1ainHp5BtXwr40Yt/CEk
         ZFiAsHJ5LCxrQzr+CSm7zPOrYq4WS/ABkhuq3pDLX/eEE6BqqxeDNlYlG9v+35h15HrM
         Y8WNNArIZbAyX6/uqXbCfPZtZJSZpq4xmnIbOFfDZBy4lBsfUwwj9DzxnEVABGzZwCxo
         roiA==
X-Forwarded-Encrypted: i=1; AJvYcCVPhyuaUAscRMzrtp9ZCHL1O9uRMDkKdNT8XGmEJNTkseeyhzYhCzmbDOTAA1V6r31mB+m4D6eKKbD4qtvjUpPEMsZ2sswtXGeyyXrNBw==
X-Gm-Message-State: AOJu0Yyt9EGPwvo8Eh6Rmnjs9rX8qU/b8aZW4ztQs6f5BOmrxSZNfXPb
	Q/CXAmA48mw6swq+Yb01FKbj6mawDC0UYEeI4qsthi/CrwNKJ9O7pm9M/4DE0Gc=
X-Google-Smtp-Source: AGHT+IFqDFgHKrPPybsbXgR9W6pXr6lzRXXb8Y6SzZTFgfvrdPD2EJsqc/1laDwrKtXZfHf421suaw==
X-Received: by 2002:a50:9ec8:0:b0:56e:743:d4d9 with SMTP id 4fb4d7f45d1cf-57832c6c0c6mr724613a12.42.1716372328602;
        Wed, 22 May 2024 03:05:28 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5782859f7ffsm1622311a12.83.2024.05.22.03.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 03:05:28 -0700 (PDT)
Date: Wed, 22 May 2024 12:05:26 +0200
From: Petr Mladek <pmladek@suse.com>
To: Lukas Hruska <lhruska@suse.cz>
Cc: mbenes@suse.cz, jpoimboe@kernel.org, joe.lawrence@redhat.com,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, mpdesouza@suse.com,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 2/6] livepatch: Add klp-convert tool
Message-ID: <Zk3DZtIr4fWaukO9@pathway.suse.cz>
References: <20240516133009.20224-1-lhruska@suse.cz>
 <20240516133009.20224-3-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240516133009.20224-3-lhruska@suse.cz>

On Thu 2024-05-16 15:30:05, Lukas Hruska wrote:
> Livepatches need to access external symbols which can't be handled
> by the normal relocation mechanism. It is needed for two types
> of symbols:
> 
>   + Symbols which can be local for the original livepatched function.
>     The alternative implementation in the livepatch sees them
>     as external symbols.
> 
>   + Symbols in modules which are exported via EXPORT_SYMBOL*(). They
>     must be handled special way otherwise the livepatch module would
>     depend on the livepatched one. Loading such livepatch would cause
>     loading the other module as well.
> 
> The address of these symbols can be found via kallsyms. Or they can
> be relocated using livepatch specific relocation sections as specified
> in Documentation/livepatch/module-elf-format.txt.
> 
> --- /dev/null
> +++ b/scripts/livepatch/klp-convert.c
> +/* Converts rela symbol names */
> +static bool convert_symbol(struct symbol *s)
> +{
> +	char lp_obj_name[MODULE_NAME_LEN];
> +	char sym_obj_name[MODULE_NAME_LEN];
> +	char sym_name[KSYM_NAME_LEN];
> +	char *klp_sym_name;
> +	unsigned long sym_pos;
> +	int poslen;
> +	unsigned int length;
> +
> +	static_assert(MODULE_NAME_LEN >= 56 && KSYM_NAME_LEN == 512,
> +			"Update limit in the below sscanf()");
> +
> +	if (sscanf(s->name, KLP_SYM_RELA_PREFIX "%55[^.].%55[^.].%511[^,],%lu",
> +			lp_obj_name, sym_obj_name, sym_name, &sym_pos) != 4) {
> +		WARN("Invalid format of symbol (%s)\n", s->name);
> +		return false;
> +	}
> +
> +	poslen = calc_digits(sym_pos);
> +
> +	length = strlen(KLP_SYM_PREFIX) + strlen(sym_obj_name)
> +		 + strlen(sym_name) + sizeof(poslen) + 3;

There should be "poslen" instead of "sizeof(poslen)".

> +
> +	klp_sym_name = calloc(1, length);
> +	if (!klp_sym_name) {
> +		WARN("Memory allocation failed (%s%s.%s,%lu)\n", KLP_SYM_PREFIX,
> +				sym_obj_name, sym_name, sym_pos);
> +		return false;
> +	}
> +
> +	if (safe_snprintf(klp_sym_name, length, KLP_SYM_PREFIX "%s.%s,%lu",
> +			  sym_obj_name, sym_name, sym_pos)) {
> +
> +		WARN("Length error (%s%s.%s,%lu)", KLP_SYM_PREFIX,
> +				sym_obj_name, sym_name, sym_pos);
> +		free(klp_sym_name);
> +		return false;
> +	}
> +
> +	s->name = klp_sym_name;
> +	s->sec = NULL;
> +	s->sym.st_name = -1;
> +	s->sym.st_shndx = SHN_LIVEPATCH;
> +
> +	return true;
> +}
> --- /dev/null
> +++ b/scripts/livepatch/klp-convert.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2016 Josh Poimboeuf <jpoimboe@redhat.com>
> + * Copyright (C) 2017 Joao Moreira   <jmoreira@suse.de>
> + *
> + */
> +
> +#define SHN_LIVEPATCH		0xff20
> +#define SHF_RELA_LIVEPATCH	0x00100000
> +#define MODULE_NAME_LEN		(64 - sizeof(GElf_Addr))
> +#define WARN(format, ...) \
> +	fprintf(stderr, "klp-convert: " format "\n", ##__VA_ARGS__)

Nit: I would remove "\n" here and add it to all callers. Half of the
     callers already have it ;-)

> +
> +/*
> + * klp-convert uses macros and structures defined in the linux sources
> + * package (see include/uapi/linux/livepatch.h). To prevent the
> + * dependency when building locally, they are defined below. Also notice
> + * that these should match the definitions from the targeted kernel.
> + */
> +
> +#define KLP_RELA_PREFIX			".klp.rela."
> +#define KLP_SYM_RELA_PREFIX		".klp.sym.rela."
> +#define KLP_SYM_PREFIX			".klp.sym."

Otherwise, it looks good.

Best Regards,
Petr

