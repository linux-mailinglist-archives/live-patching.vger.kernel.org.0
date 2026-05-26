Return-Path: <live-patching+bounces-2888-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YMv1GiCbFWryWgcAu9opvQ
	(envelope-from <live-patching+bounces-2888-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 15:07:44 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D5AF45D60D0
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 15:07:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D8FD4301052B
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 13:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF0E21256C;
	Tue, 26 May 2026 13:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cQNHzapT"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E500B395AF8
	for <live-patching@vger.kernel.org>; Tue, 26 May 2026 13:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779800692; cv=none; b=DENUeA6wKTUSfxI+WKNwwtWKWP4IB5qWX4NdW0bswvWNHE7ZYCeNVlQqwge8ygMshx2Qn0q43ycgX8+nYc1lJbjcT+j9gLAszpfKRfbrRLQdJqFlgROJ9/U5Q0ABd3507yNe0lCTziM1Tb/LeaUbyK5jXHzFmxr43Dy//J3TI6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779800692; c=relaxed/simple;
	bh=m7Q9A3BsA4g5ShdylxUqNbaVpn6Gex+vbVoZLZB2cCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m6ltp5BSnLm0aS5Z2mEaJRBRq1DDofVh2BZ3HfBibhDDalPn/W4vKc9MUQhTBIq0j9G2xP/dBkQmqq1+XneXIvELY5vftXaR26fVSXoLNEnYGVVptJ7z1NrQZXp9wpN55g8bRQOoIo2LenKTYRmNGfDzDP5iBkdTXm/OQ+I/hJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cQNHzapT; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45ed9336049so406075f8f.0
        for <live-patching@vger.kernel.org>; Tue, 26 May 2026 06:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779800689; x=1780405489; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=myRDjcw9KKQ2OHHG8nnh9SbYNyjk9ns/M4+PR6HC5RY=;
        b=cQNHzapTFU38ZhdYrKeSbBpGnwCgxFrWEfI+gfYsEZfi8h+W/Mz4qbotGOaWI0OD7n
         Tj4a85AudQumBPLuc7C5BxwEXN0N8xRRhBJdeRehfCoBDd3mZWypYXZipA649HT9409B
         zK2HyrCSx/MYNTE73u31P0r3Ybx1U6E3PQBf7EFFglmdFY67CSMumzZ4f8ZLZAhiQtxX
         C20XlFfQD8VCCW03e60lcd8MaPfDCTJp8uN1LOnF6O4/Mgqd9o4M8z5Dwib3QLKcTGND
         a4PBPwY9yLuBdq7cX7+k2BYJhh/qIzFLOtYsn+DNkwETjrZyCWu2pWf1BnJMF0MqgamG
         igog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779800689; x=1780405489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=myRDjcw9KKQ2OHHG8nnh9SbYNyjk9ns/M4+PR6HC5RY=;
        b=r0UHV8lSVX1CF7La5xfa5OM7LmyFGuS57QzkUxeV//jSM+dwgouI3TmWgF9UE6HLjg
         ezGIcRzr+fNKOoYRiObHmaXjfF0LoAMcduYWoGU/gKuxWKVZE5WFKPA9cxhPZF8LGn/f
         rbyaEENMMf8Ide5pGsGYEJtgQHU9W6pWrxS/X6Zy5h1vuuN91WCwr8pQswoSY1rL6A6T
         uIQeDqcbfxsxU0nOdo22cpUD6dSvUebh/Zs9rQsxcmrJzSwbBHH0FYzBNYvgjtqkzdLH
         llAsRlvDgHpvy4h39X56o+lExFXgvkEzvNYhufcio1uNYDwMr533l3ECi3H3IDG7FjFy
         Su3Q==
X-Forwarded-Encrypted: i=1; AFNElJ81DhUsg5k7G0Up9gA18grvR9/DZxOBnBdlevSsELr28Mw/xbNIojjwT1EUQi9eOWctNl6KrMxHX0n4NcwV@vger.kernel.org
X-Gm-Message-State: AOJu0YyattXZ3lzfeW8lVSIUchkiS8bLfDwL1inDnXAJgrZQYAb5kLcR
	T4bIRVHl4Bvw6jh+xepfUbxd8I2gB3INGl7n2xGi56RJCzprXVKiNJMIa58mi1M+xWU=
X-Gm-Gg: Acq92OEMme62NvRL5+F6OT0loa2f8xhxZmEAo+otrePDzCCEdRxbK4sEqIzvbJ/OEiI
	Dh+WxrOyRlVIGMLoh5hkFdEASKjmIYlj6V6WGqEIqzcaQT/LQ+yPcehXqVNpZh/KYfwJa29AWy+
	HHtNNVD3YQrYlaoVBP/nxhzomp/YP2Nidfh6mGAjxC5x4nY4Ioi8hLZpftw15Kwe59NhhPl3Rp5
	9Gd/Mr3bXIyjA49b3teB87el6Vo5qdg6BXvriuTLxexxXBrrMani7/qXRZpSYE75JwJB3g5Z6LE
	M9gUgIwKXewW3sLS8B8XhxGDhamAZbt0GWINDLTr6sy/1aAfbES1wgZTNFsPgAMG86nDygajj0B
	eLEnabpzvkjJBz50efMHZS5tPa51o+cefJtRR/7SF7i2D7TDhYf6AxgyS+YoamYZO+akgPsjMk7
	dfk9ngEX3JJYcEJveoUZgeBRGM5w==
X-Received: by 2002:a05:6000:4905:b0:439:beb9:5a96 with SMTP id ffacd0b85a97d-45eb389fde2mr27656002f8f.31.1779800689177;
        Tue, 26 May 2026 06:04:49 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5cb76sm31082573f8f.25.2026.05.26.06.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 06:04:48 -0700 (PDT)
Date: Tue, 26 May 2026 15:04:47 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, song@kernel.org,
	live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] livepatch: Support replace_set in shadow
 variable API
Message-ID: <ahWaby45THrzbwDK@pathway.suse.cz>
References: <20260513143321.26185-1-laoar.shao@gmail.com>
 <20260513143321.26185-7-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513143321.26185-7-laoar.shao@gmail.com>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2888-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.com:dkim,pathway.suse.cz:mid]
X-Rspamd-Queue-Id: D5AF45D60D0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed 2026-05-13 22:33:21, Yafang Shao wrote:
> To support more complex livepatching scenarios where multiple
> replacement sets might coexist, extend the klp_shadow API to
> include a 'replace_set' identifier.
> 
> To maintain compatibility with the existing 64-bit storage in
> 'struct klp_shadow', the internal @id is now treated as a composite
> value. The 64-bit identifier is constructed by packing two 32-bit
> values:
> 
>   MSB (63-32)          LSB (31-0)
>   +--------------------+--------------------+
>   |    replace_set     |    original @id    |
>   +--------------------+--------------------+
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/linux/livepatch.h | 12 ++++---
>  kernel/livepatch/shadow.c | 70 ++++++++++++++++++++++++---------------
>  kernel/livepatch/state.c  |  3 +-
>  3 files changed, 52 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 221f176f1f51..2dd9fca8c01c 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -195,15 +195,17 @@ static inline bool klp_have_reliable_stack(void)
>  	       IS_ENABLED(CONFIG_HAVE_RELIABLE_STACKTRACE);
>  }
>  
> -void *klp_shadow_get(void *obj, unsigned long id);
> -void *klp_shadow_alloc(void *obj, unsigned long id,
> +void *klp_shadow_get(void *obj, unsigned int replace_set, unsigned int id);
> +void *klp_shadow_alloc(void *obj, unsigned int replace_set, unsigned int id,
>  		       size_t size, gfp_t gfp_flags,
>  		       klp_shadow_ctor_t ctor, void *ctor_data);
> -void *klp_shadow_get_or_alloc(void *obj, unsigned long id,
> +void *klp_shadow_get_or_alloc(void *obj, unsigned int replace_set, unsigned int id,
>  			      size_t size, gfp_t gfp_flags,
>  			      klp_shadow_ctor_t ctor, void *ctor_data);
> -void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor);
> -void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor);
> +void klp_shadow_free(void *obj, unsigned int replace_set, unsigned int id,
> +		     klp_shadow_dtor_t dtor);
> +void klp_shadow_free_all(unsigned int replace_set, unsigned int id,
> +			 klp_shadow_dtor_t dtor);
>  
>  struct klp_state *klp_get_state(struct klp_patch *patch, unsigned long id);
>  struct klp_state *klp_get_prev_state(unsigned long id);
> diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
> index c2e724d97ddf..35e507fae445 100644
> --- a/kernel/livepatch/shadow.c
> +++ b/kernel/livepatch/shadow.c
> @@ -48,7 +48,8 @@ static DEFINE_SPINLOCK(klp_shadow_lock);
>   * @node:	klp_shadow_hash hash table node
>   * @rcu_head:	RCU is used to safely free this structure
>   * @obj:	pointer to parent object
> - * @id:		data identifier
> + * @id:		combined data identifier
> + *		higher 32 bits: replace_set, lower 32 bits: resource ID

I am not sure if this is worth the complexity.

The 2nd patch allows to associate klp state ID with klp shadow ID.
People should really use it because it helps to maintain the lifetime
of shadow variables and makes it safe.

Then we could refuse loading livepatches with a shadow/state ID when
it is already being used by another livepatch with another "replace_set".

>   * @data:	data area
>   */
>  struct klp_shadow {

Best Regards,
Petr

