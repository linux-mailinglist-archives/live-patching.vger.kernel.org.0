Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42824BE54D
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 19:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351346AbiBUJsw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 04:48:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353188AbiBUJsP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 04:48:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3CCBDEF3
        for <live-patching@vger.kernel.org>; Mon, 21 Feb 2022 01:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645435344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ad6pMafFuKoh5sHuoaKN4WCBkg6hpge8kEYbZzG0l/U=;
        b=BShNKK4/BRPPO07L0KZiROY5AvXts06ccZyVVVCYlDtLuKnZ0uj/j5yXaQ1ZLDzJfhJCJD
        AP4xFGruoa8Y+E8Pw4Fi8UHj7knkM12CD/560yvT4BqDwwt1CDJSOCmJMgybVCN6J8MPH0
        EZEdT8w5snYH6EFlwMaMEguCzZ9Ul3U=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-ZPRzHNh_PROBAWAJxiANSQ-1; Mon, 21 Feb 2022 04:22:22 -0500
X-MC-Unique: ZPRzHNh_PROBAWAJxiANSQ-1
Received: by mail-lj1-f200.google.com with SMTP id q17-20020a2e7511000000b0023c95987502so3769531ljc.16
        for <live-patching@vger.kernel.org>; Mon, 21 Feb 2022 01:22:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ad6pMafFuKoh5sHuoaKN4WCBkg6hpge8kEYbZzG0l/U=;
        b=6b3OmdCuLaptvQEPslzqmur2CHjE3oHDEHRAaIIKLUtL72NwYzZLpkKLE7foXhDR6w
         Y7l2AreHvnWXxpE1IjGQTjk23CdiwlQP8jbuNDP7TA2cTfgfkSKQ3gUHhGjegPapQUeu
         vgP0xEF350tjOSAcU3sa1fYppIp3iyaQbUG1vTTJorFpt0G9he/r3y2/dHt7OYRQq1OW
         IzyLOi1M4QyS8HyNgOf6jRr8cioFtiuI49h9HZT3Lzquo7srdypPOmYf1r7aj2Zb5PMt
         69k2v8F7h7xf1hzElGZWFSHjQOY9qgFnCeTaZsVXGE2f3eHXb0w8msvDgZDIGiJagY2/
         AQiQ==
X-Gm-Message-State: AOAM530EO/Z2S1JVFlpnZKo1/Zl62820dXMhjIeLllv465HKpCp2YMQj
        iGptXeC4krOwf5pSbMQ0pOk3DX41uTgJgzGvCeP3GQw8sKWrRnI615FFrZeQ0U7AUSChi2XmhWn
        zFFmXbK5SIlfKMe+rljuMe4FzLVHdus+0S5wpcXfO
X-Received: by 2002:a2e:8856:0:b0:246:3bfd:dfc8 with SMTP id z22-20020a2e8856000000b002463bfddfc8mr4005589ljj.405.1645435341125;
        Mon, 21 Feb 2022 01:22:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwqqElMWCPmmeG9e4i5Pf9cAy5vbIeUUzK6mO8pXI5G7HWPoGAJ9x/Nr5EHYWLmz2n3K18txAXAxXAugY7cAS4=
X-Received: by 2002:a2e:8856:0:b0:246:3bfd:dfc8 with SMTP id
 z22-20020a2e8856000000b002463bfddfc8mr4005570ljj.405.1645435340975; Mon, 21
 Feb 2022 01:22:20 -0800 (PST)
MIME-Version: 1.0
References: <20220218212511.887059-1-atomlin@redhat.com> <20220218212511.887059-10-atomlin@redhat.com>
 <98cff67e-d2ca-705b-7c83-bd3f41df98d9@csgroup.eu> <0ea89614-9bab-99f5-47a8-2a2996c38966@csgroup.eu>
In-Reply-To: <0ea89614-9bab-99f5-47a8-2a2996c38966@csgroup.eu>
From:   Aaron Tomlin <atomlin@redhat.com>
Date:   Mon, 21 Feb 2022 09:22:09 +0000
Message-ID: <CANfR36iGqX93rvv1M6AwGdR=C-Ev314iKCMpEzHOO0-LXAzJig@mail.gmail.com>
Subject: Re: [PATCH v6 09/13] module: Move kallsyms support into a separate file
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "Lameter, Christoph" <cl@linux.com>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, jeyu@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        Aaron Tomlin <atomlin@atomlin.com>,
        Grzegorz Halat <ghalat@redhat.com>,
        Allen <allen.lkml@gmail.com>, Joe Perches <joe@perches.com>,
        Michal Suchanek <msuchanek@suse.de>, oleksandr@natalenko.name
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-02-21 09:35 +0100, Christophe Leroy wrote:
> Fixup:
>
> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
> index 6c8f1f390cf5..2ee8d2e67068 100644
> --- a/kernel/module/kallsyms.c
> +++ b/kernel/module/kallsyms.c
> @@ -171,8 +171,7 @@ void add_kallsyms(struct module *mod, const struct
> load_info *info)
>      Elf_Shdr *symsec = &info->sechdrs[info->index.sym];
>
>      /* Set up to point into init section. */
> -    mod->kallsyms = (struct mod_kallsyms __rcu *)mod->init_layout.base +
> -        info->mod_kallsyms_init_off;
> +    mod->kallsyms = (void __rcu *)mod->init_layout.base +
> info->mod_kallsyms_init_off;
>
>      /* The following is safe since this pointer cannot change */
>      rcu_dereference_sched(mod->kallsyms)->symtab = (void *)symsec->sh_addr;

Agreed.

-- 
Aaron Tomlin

