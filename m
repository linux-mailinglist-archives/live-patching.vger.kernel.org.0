Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5F16D0463
	for <lists+live-patching@lfdr.de>; Thu, 30 Mar 2023 14:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjC3MKJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 30 Mar 2023 08:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjC3MKI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 30 Mar 2023 08:10:08 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2744202;
        Thu, 30 Mar 2023 05:10:07 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t10so75404019edd.12;
        Thu, 30 Mar 2023 05:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680178206;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GiRnxJYGLZl9gkE3Btj0DPwx3kYOXRqdQVjP40JuFAY=;
        b=F1ak3hFr6X15BX5WccChl/IPbvU4a7NsfyYFRjtDQM6zmbxrqsLndm7btSBas8MJug
         5tYIT50GpNMwK+mHzCvXXbZVNnOXh5Kqlpiz7/pvAOPxajXyiqpMrZM/SUUkzgNZPvEf
         cW1+Epw8vv8URa2lBH4luvQP9dCvDn+Nr/nENjnZdhJ136wYh7uJMEZvOUbZSDaCKf46
         48uA6AavC3uxBWsja340ItGoXOtQjd5Is0gBDpjjpq39kHdTlu0bf1N4rgv/CrhMSoOT
         WRdXGG89dDMtxDhnM4gY5A1A+ScbIebdypev6ZMAag0pkpColvlhIu3fXpXsfusDWI1O
         mZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680178206;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GiRnxJYGLZl9gkE3Btj0DPwx3kYOXRqdQVjP40JuFAY=;
        b=i8bCWKCf/kbGxxKQZ/hXz5Cra1hkj+7Ziq7bCehs0ZZyfkFbAEckWNcwpRxOCuWy97
         th99z5Tmz8GICYfbWaHG3q5WEunBWXaKl2Zzvq1gCQXLP4N0QOT3424BHSObgnzFpp9H
         DilCzRu5sYv4OGsk6QVF7bwoDwqdYlJcaM1e51w9zv7fIMks8ZPuXK7/bgRlvelZk+YI
         kTc9t5AP44dFEcdcSBDl5N6CACm8xCeyG8wojOBHEqX2RZvXonuAa1FA+DwF+goDMAkt
         +kn4+wScbmhDCdgouVOTpUZbzGT8Fp3XskqUNnoTZQBNojJ1C2wizxq9xfqvTHztOrnW
         wVTQ==
X-Gm-Message-State: AAQBX9de+xzZe30nhlOnWL9j7B8f0n66kWkGRqvdBKKPkIxj/5K8xFxZ
        6jXG4QQcl/ZN6oaLBzpOjQ==
X-Google-Smtp-Source: AKy350Zt+zKYRtASMyO2Hfp4ote3ijZixO0WLMsgGlHbfFsFILT/LFdYa7SPhV+hemG7ymdoyq/vEg==
X-Received: by 2002:a17:907:9725:b0:93f:9594:d97d with SMTP id jg37-20020a170907972500b0093f9594d97dmr20670831ejc.14.1680178205762;
        Thu, 30 Mar 2023 05:10:05 -0700 (PDT)
Received: from p183 ([46.53.250.0])
        by smtp.gmail.com with ESMTPSA id i11-20020a170906264b00b009255b14e91dsm17519658ejc.46.2023.03.30.05.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 05:10:05 -0700 (PDT)
Date:   Thu, 30 Mar 2023 15:10:03 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v7 00/10] livepatch: klp-convert tool
Message-ID: <4ce29654-4e1e-4680-9c25-715823ff5e02@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Joe Lawrence wrote:
> +static int update_strtab(struct elf *elf)
> +{
>
> +	buf = malloc(new_size);
> +	if (!buf) {
> +		WARN("malloc failed");
> +		return -1;
> +	}
> +	memcpy(buf, (void *)strtab->data, orig_size);

This code is called realloc(). :-)

> +static int write_file(struct elf *elf, const char *file)
> +{
>
> +	fd = creat(file, 0664);
> +	e = elf_begin(fd, ELF_C_WRITE, NULL);

elf_end() doesn't close descriptor, so there is potentially corrupted
data. There is no unlink() call if writes fail as well.

> +void elf_close(struct elf *elf)
> +{
> +
> +	if (elf->fd > 0)
> +		close(elf->fd);

Techically, it is "fd >= 0".

> +filechk_klp_map = \
> +	echo "klp-convert-symbol-data.0.1";		\
> +	echo "*vmlinux";				\
> +	$(NM) -f posix vmlinux | cut -d\  -f1;		\
> +	sort $(MODORDER) $(MODULES_LIVEPATCH) |		\

This probably should be "LC_ALL=C sort" for speed and reproducibility (?).
