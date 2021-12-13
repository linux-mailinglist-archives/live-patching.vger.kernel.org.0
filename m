Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16EE472FB8
	for <lists+live-patching@lfdr.de>; Mon, 13 Dec 2021 15:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhLMOro (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Dec 2021 09:47:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230272AbhLMOro (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Dec 2021 09:47:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639406863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A8hcGLH+T0gUqYBZFFXWjQPxtS91IvQDULYdbE3ot/k=;
        b=fWP4Ss1N8aU9S8vaTBxdPzLt3SShW/F25XIHIoz1BUcUiJfd9/92y+TnrwzmkpEyLRu3LJ
        D4ZATqp5V7PGEoCrVQpb1JlyunaNRsM+3TpHYgKibve3LuS8TdHmbXhzuSY5ko7w1VVb27
        z26KQr1Rn6gzOs1j2RBOC+nYRh9qV1k=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-555-_DpyAXbuNTKsRZYciZ936Q-1; Mon, 13 Dec 2021 09:47:42 -0500
X-MC-Unique: _DpyAXbuNTKsRZYciZ936Q-1
Received: by mail-qt1-f198.google.com with SMTP id w14-20020ac87e8e000000b002b6583adcfcso23601502qtj.0
        for <live-patching@vger.kernel.org>; Mon, 13 Dec 2021 06:47:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A8hcGLH+T0gUqYBZFFXWjQPxtS91IvQDULYdbE3ot/k=;
        b=mmL7bC/wCtMVJxNwScdRxJiroX1el17WwsAHjqc292czYkB+06Cc2qlaFnAE3c9iZ0
         R9+uLUS2STTwQkPsx5P3LPDMpwsr2OkVk0nMzkw8hxZTqMEmD6x1gK5MxgucG85ZYTiv
         zO2ErjRrPgQlocTGkjFY8vUGnDavltB9F3tjk6Aelq/H+F38FK4Mz44rKZHoFt11gfg0
         fAcOHbbQ2WY+WN8uuag1aQiYZfz0NvTZ5N/npbeJhYh6UnzdI6VN5UKDcs1w7uGmsjKd
         qK82CHCS9YtTDdXtTIyRdt9lTLDoXqAIPFaz8WzUryRF+VhhkUwKh9LDmntR7W69uLh+
         +RWw==
X-Gm-Message-State: AOAM533a1oHvYtTK6h0RiG7+J8zjNTnc2FY7JEeQeea8I9jv2vSHJn9r
        vT8AxxieHdbVvo+pckPhqVte5oPxufzEapLT0l3gMG1BGJ+f8Md6monEbLVBlpQdIcJEPliE6TK
        Bjqx2pTTjUtq/J+GVSBUfPH6/LQ==
X-Received: by 2002:a05:620a:1a8d:: with SMTP id bl13mr33725403qkb.200.1639406862156;
        Mon, 13 Dec 2021 06:47:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy1pytTz0rFDYInzO60wUAQXH29a2E/VAmEu6qrge4tTzr5qgfYjG6Yp5J6Sqb4lCXlwrm7qw==
X-Received: by 2002:a05:620a:1a8d:: with SMTP id bl13mr33725367qkb.200.1639406861848;
        Mon, 13 Dec 2021 06:47:41 -0800 (PST)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id o17sm6004570qkp.89.2021.12.13.06.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 06:47:41 -0800 (PST)
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Russell Currey <ruscur@russell.cc>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jordan Niethe <jniethe5@gmail.com>
References: <YX9UUBeudSUuJs01@redhat.com>
 <7ee0c84650617e6307b29674dd0a12c7258417cf.camel@russell.cc>
 <f8a96ac1-fda3-92da-cf27-0992a43a2f3f@redhat.com>
 <bed88ff4-e5d3-4b78-4f28-29fc635c2f97@csgroup.eu>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: ppc64le STRICT_MODULE_RWX and livepatch apply_relocate_add()
 crashes
Message-ID: <919a79b8-feff-b0a4-b96a-73f376b7f6dc@redhat.com>
Date:   Mon, 13 Dec 2021 09:47:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <bed88ff4-e5d3-4b78-4f28-29fc635c2f97@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 12/13/21 2:42 AM, Christophe Leroy wrote:
> 
> Hello Joe,
> 
> I'm implementing LIVEPATCH on PPC32 and I wanted to test with 
> STRICT_MODULE_RWX enabled so I took your branch as suggested, but I'm 
> getting the following errors on build. What shall I do ?
> 
>    CALL    scripts/checksyscalls.sh
>    CALL    scripts/atomic/check-atomics.sh
>    CHK     include/generated/compile.h
>    KLP     lib/livepatch/test_klp_convert1.ko
> klp-convert: section .rela.klp.module_relocs.test_klp_convert_mod length 
> beyond nr_entries
> 
> klp-convert: Unable to load user-provided sympos
> make[2]: *** [scripts/Makefile.modfinal:79: 
> lib/livepatch/test_klp_convert1.ko] Error 255
>    KLP     lib/livepatch/test_klp_convert2.ko
> klp-convert: section .rela.klp.module_relocs.test_klp_convert_mod length 
> beyond nr_entries
> 
> klp-convert: Unable to load user-provided sympos
> make[2]: *** [scripts/Makefile.modfinal:79: 
> lib/livepatch/test_klp_convert2.ko] Error 255
>    KLP     lib/livepatch/test_klp_convert_sections.ko
> klp-convert: section .rela.klp.module_relocs.test_klp_convert_mod length 
> beyond nr_entries
> 
> klp-convert: Unable to load user-provided sympos
> make[2]: *** [scripts/Makefile.modfinal:79: 
> lib/livepatch/test_klp_convert_sections.ko] Error 255
> make[2]: Target '__modfinal' not remade because of errors.
> make[1]: *** [scripts/Makefile.modpost:145: __modpost] Error 2
> make: *** [Makefile:1770: modules] Error 2
> 

Hi Christophe,

Interesting failure mode.  That's klp-convert complaining that it found
more relocations in a .klp.module_relocs.<objname> section than
expected, i.e. nr_entries = sec->size / sizeof(struct klp_module_reloc).

A few possibilities: the ELF sec->size was incorrectly set/read by
build/libelf (I doubt that).  Or maybe the layout/size of struct
klp_module_reloc is not consistent between kernel and userspace (I'm
more suspicious of this).

Can you post a copy of the build's symbols.klp and
lib/livepatch/test_klp_convert1.tmp.ko somewhere?  I should be able to
start debug with those files.

Thanks,
-- 
Joe

