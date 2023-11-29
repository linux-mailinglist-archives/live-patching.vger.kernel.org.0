Return-Path: <live-patching+bounces-53-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C9C7FD8B5
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 14:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D905B214DC
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 13:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFBB225D9;
	Wed, 29 Nov 2023 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bp9Ils0f"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF53C10E0
	for <live-patching@vger.kernel.org>; Wed, 29 Nov 2023 05:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701266005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fCRlZ8oiqaJTBcB7G2DHmy/vp26Z550XjGVY3C3y2Oo=;
	b=Bp9Ils0fKZ2EoAPIbvNkEYO+UTkL9GZnYvtvkblh6i2jQZZG9Gqz3chpLjxWdg2DTktc6m
	T8qSvLoOwChGOhqlNXbwdjYB8D+ehWhrn+994v2dRi8+RGCD2vL57mDxm057XIpUKUckGI
	l1l9XKeGzGju1uNsk/ahLJnDTOqDFT0=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-jMan9-KUNDS8uoJQ05w08w-1; Wed, 29 Nov 2023 08:53:24 -0500
X-MC-Unique: jMan9-KUNDS8uoJQ05w08w-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-4644ca0a48aso156862137.2
        for <live-patching@vger.kernel.org>; Wed, 29 Nov 2023 05:53:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701266004; x=1701870804;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fCRlZ8oiqaJTBcB7G2DHmy/vp26Z550XjGVY3C3y2Oo=;
        b=wIelomNJkPnu3fej6EvbWGx+sIvI7xMwVH5GtoAJpJULnHfkgg/0D4mMe4n0Z+SFlv
         q9B3Tg4D/QxDYCfyAJcKi1c5Eg/LwugcX/XSA7TN0vGK/6Shq9/HEjNJh5WfiBc1L/MC
         gzpcsLBdnhA37PSnzon+8rXh5FpPo7krAZvp1MjBn9GKb5N5s0UmmE6g8lLBv6LsRM4z
         dkbZajhlaeBaRtTSeBOssKO5yN8aIwD5WOEEzl2X2CF+z8hyh5uDIFekEghH9CHbVc8v
         4zCOgGIMIGqMDlT++ZKPf83yNWvqmNQb7+/jc+8dlpK5ZLeFS/GUYppwvz3mzmIIrx4l
         mPpw==
X-Gm-Message-State: AOJu0YzL/XF3jpuvQHmgZTMdH6C2bP4fdrzsDDixyuFS9djUlT+KsUX/
	yQ/7+L6AqRBpzhuH/UGxrFX524gj3bk7SRbsr+HcNPvgcEqw19uY0dVJRiwfOccfaf5fQZXvaRE
	5NhaL+nTXNvGds1ooxUDHA85DJA==
X-Received: by 2002:a05:6102:34d1:b0:464:4f99:67cd with SMTP id a17-20020a05610234d100b004644f9967cdmr898018vst.25.1701266003954;
        Wed, 29 Nov 2023 05:53:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG6XeoX3LySftJvfhNd92B8TROaD2k49rLLui+JpiO50N4F9wBA4UISs6o9ymk2BLyZlpB5+Q==
X-Received: by 2002:a05:6102:34d1:b0:464:4f99:67cd with SMTP id a17-20020a05610234d100b004644f9967cdmr897999vst.25.1701266003740;
        Wed, 29 Nov 2023 05:53:23 -0800 (PST)
Received: from [192.168.1.9] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id s7-20020a0cf647000000b0067a4396f9cdsm3018175qvm.8.2023.11.29.05.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Nov 2023 05:53:23 -0800 (PST)
Message-ID: <ac7a90a7-4d29-059b-fbff-6b67e6f5c2d3@redhat.com>
Date: Wed, 29 Nov 2023 08:53:22 -0500
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux Kernel Livepatching <live-patching@vger.kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Attreyee Mukherjee <tintinm2017@gmail.com>
References: <20231129132527.8078-1-bagasdotme@gmail.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH 0/2] Minor grammatical fixup for livepatch docs
In-Reply-To: <20231129132527.8078-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/29/23 08:25, Bagas Sanjaya wrote:
> I was prompted to write this little grammar fix series when reading
> the fix from Attreyee [1], with review comments requesting changes
> to that fix. So here's my version of the fix, with reviews from [1]
> addressed (and distinct grammar fixes splitted).
> 

Typical kernel workflow would be for Attreyee to incorporate feedback
and post their v2 after a day or two.  From the format they posted, it
appears to be a first(ish) kernel contribution post.  Let's be kind and
patient so they we all may benefit from the practice of iterating on
their patch.

-- 
Joe


