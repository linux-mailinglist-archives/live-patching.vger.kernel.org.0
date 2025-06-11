Return-Path: <live-patching+bounces-1517-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 155AEAD61B8
	for <lists+live-patching@lfdr.de>; Wed, 11 Jun 2025 23:44:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E5037AA936
	for <lists+live-patching@lfdr.de>; Wed, 11 Jun 2025 21:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22789244697;
	Wed, 11 Jun 2025 21:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MgkmsIBn"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7FC244669
	for <live-patching@vger.kernel.org>; Wed, 11 Jun 2025 21:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749678270; cv=none; b=Zkld/nEkX6sBplBO1/+vwBLQU/oy0lfYDB4ZToY6sajLarrEaUTwzoK88TTzTtllOga2TPhAFgvNz246ZIulQ/jhJSjAUyBfI9mLt3tuuhcluxIAZ+390bAnnrSd86PUrlSb4GC+FKuLRgUvlJ4jaB17adCktxDyTrIwov3LQ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749678270; c=relaxed/simple;
	bh=5iibx60+X4DCGlBZs5v7NCxPcgpAC/Wgvg/rfdqJWKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=prfiVlE3YGP4ogu1UDgQdxM7FfkQpXfQSK1qQIKuMruPwce6qGIiiFOvt0a5pd4mNBY8KGu0au/UY4g7mXGe1mPLwJaEsPCWr7NdP3YYyRsKw2hwGb20dKIBjcMomHfA3Ue3hNq3r7VgkejDagJnjbThO5nwA+TxVSC84yxiwKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MgkmsIBn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749678267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YuNV+uFz+bCVOpICqXLxMO9nlU4x45XUkHUtMtKxB7Q=;
	b=MgkmsIBnrOK9rVD0Jm/vSrK3BLeexM4u5VRf8e3IqC2decIsIj7bBAOFh+GseKeVh1WLlZ
	8LL6mt1ITuAm1KlFMhj32EbW236+ABHZPTSW0RGrrL6Q+w6N2w1H4DVIu4qtwftYWv4Fyy
	c7y+WXa0BycDA1PX5Q0Iw9V7zxIhQR0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-d29ZnItmO2y7NGMyLk3BWw-1; Wed, 11 Jun 2025 17:44:26 -0400
X-MC-Unique: d29ZnItmO2y7NGMyLk3BWw-1
X-Mimecast-MFC-AGG-ID: d29ZnItmO2y7NGMyLk3BWw_1749678266
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4a441a769c7so8160821cf.3
        for <live-patching@vger.kernel.org>; Wed, 11 Jun 2025 14:44:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749678266; x=1750283066;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YuNV+uFz+bCVOpICqXLxMO9nlU4x45XUkHUtMtKxB7Q=;
        b=CYdAP5EkhKY6nGNa70hahv+WCyRz2fIbinpK+AJnury5bwel4biz5Uzz5d+patFKpB
         zUNOOj7dq/MXQ2gRqtgxfzfmjg1gvYmT6yhzDrxeExQz95BhoThJC+EpW8qfdESOwb+x
         BMqh5gZ+zF03LUNRROGMLoZNU8C0UOVt50kpMRdPkOTKWqdtKjmgnv26jTft3qbPPT8h
         GjmGUPfm4LqKJKp6QrB3VbAIpnmn/Q4mouzi12l559O8TqxZ3cC799XUQwDXaraOIKP0
         tOXWAHiUFUu7/8WUtNDqAUv/AofsRclvMa59NFpD9zzLJJdfxaPIrbk9W3m2SunciVfY
         mD5Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3btGP7xtYVWyERni9a4DcDRLObHmaBv08W5c93ROV+an5gNQlbjaET4+94+ObJttblS7XoWrmK9kQoJs4@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1AKv0vvVm75VKXyluDfjsNQJORCw9I5wMCV9fgsR/HQc4AJ7f
	QgFF3TPMowNyfGLmyUxrTEMruhQ1BeVddUFNEKoSA4KBpAoYzjo9mRbOSparnRlxhv6D1prrBLj
	6dHHGrwagSnG/ZUQo5RbpUHXJxO0W6Elh/dz87wrzC0NJe4Goqv2Apv9OahdPuPYeDOI=
X-Gm-Gg: ASbGncuredtllhMvSw1N5TcvHWOzls9rjU5hkjGLnApVd+axKslWzKFtTAnyMlNCXlm
	1XkDs5SW+ZEOJOG0lu67702HVHK78jYZiwu8ya55o/hYgKQsc3HKhL3U4CdrwpkEal3d/xydkwp
	u2hOowdwUJN3qxiW/1/aHwFtfA8PuI/iq98hkTcWtFDswm/uDlYAfsrQc9UVEHE9NhBIDHrLDN+
	NkRxnz9NMyxXJSv6aflK/9Lg+GHpbA9qOL3jaA6Xu/hq1Vd7TcvZL0H/MqryyT3nLxGLQa1n+a0
	KJVXqj2EKIXCP8yeENjBLqbIvbSlwFzz/mduC9CKVTSO0Z5L0EsJnyRKWAg1uxPfCJ7UfYYnH3E
	KKQ==
X-Received: by 2002:a05:622a:5a11:b0:4a3:ebbb:56e5 with SMTP id d75a77b69052e-4a713c48e92mr88441251cf.35.1749678265805;
        Wed, 11 Jun 2025 14:44:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFK+oN9pOk8Jc36x5KXmXAsK0e2wgh+i0hQcs9RHkvSyWfAYwFBWvMduaJlRikotpIIOBo/Qw==
X-Received: by 2002:a05:622a:5a11:b0:4a3:ebbb:56e5 with SMTP id d75a77b69052e-4a713c48e92mr88440901cf.35.1749678265473;
        Wed, 11 Jun 2025 14:44:25 -0700 (PDT)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a724740dbdsm1703301cf.17.2025.06.11.14.44.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jun 2025 14:44:25 -0700 (PDT)
Message-ID: <305c6d06-ae85-4595-ba05-9aa7b93739bd@redhat.com>
Date: Wed, 11 Jun 2025 17:44:23 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
 Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
 Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>,
 Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>,
 Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/9/25 4:17 PM, Josh Poimboeuf wrote:
> +revert_patches() {
> +	local extra_args=("$@")
> +	local patches=("${APPLIED_PATCHES[@]}")
> +
> +	for (( i=${#patches[@]}-1 ; i>=0 ; i-- )) ; do
> +		revert_patch "${patches[$i]}" "${extra_args[@]}"
> +	done
> +
> +	APPLIED_PATCHES=()
> +
> +	# Make sure git actually sees the patches have been reverted.
> +	[[ -d "$SRC/.git" ]] && (cd "$SRC" && git update-index -q --refresh)
> +}

< warning: testing entropy field fully engaged :D >

Minor usability nit: I had run `klp-build --help` while inside a VM that
didn't seem to have r/w access to .git/.  Since the cleanup code is
called unconditionally, it gave me a strange error when running this
`git update-index` when I never supplied any patches to operate on. I
just wanted to see the usage.

Could this git update-index be made conditional?

  if (( ${#APPLIED_PATCHES[@]} > 0 )); then
      ([[ -d "$SRC/.git" ]] && cd "$SRC" && git update-index -q --refresh)
      APPLIED_PATCHES=()
  fi

Another way to find yourself in this function is to move .git/ out of
the way.  In that case, since it's the last line of revert_patches(), I
think the failure of [[ -d "$SRC/.git" ]] causes the script to
immediately exit:

  - for foo.patch, at the validate_patches() -> revert_patches() call
  - for --help, at the cleanup() -> revert_patches() call

So if you don't like the conditional change above, should
revert_patches() end with `true` to eat the [[ -d "$SRC/.git" ]] status?
 Or does that interfere with other calls to that function throughout the
script?

FWIW, with either adjustment, the script seems happy to operate on a
plain ol' kernel source tree without git.

-- 
Joe


