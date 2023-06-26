Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3E673D81F
	for <lists+live-patching@lfdr.de>; Mon, 26 Jun 2023 08:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjFZG4q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 26 Jun 2023 02:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjFZG4m (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 26 Jun 2023 02:56:42 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173B9AC;
        Sun, 25 Jun 2023 23:56:42 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1b7fb1a82c4so3799195ad.1;
        Sun, 25 Jun 2023 23:56:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687762601; x=1690354601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u58j1CoFhNAAP0kPknc/GhPhE9N5OmJCD1ZWCCtRRgc=;
        b=WDPKuhXalnGPckp2TpIKynsO8ZnokkfdhiarQXI1U9VrqORX/RqI+YQ6iOzudxuYfh
         4q6XXJOoyqqR6QwbktPcLn3j/Hia6cNtm2Nrhm3yJiWc7JcKmjD3tVjEuADNSmK2GgDV
         xk8ovnwV1ONicO1yc5JYu90NJCKD2g0I+aPJlJcB+YR5HHSFgftpBca8XhiVusEZTmu+
         +qlUGGQiGJiMT1OVUk9z8yv0fpOv85eDrKiCyXaOhKgjcvScYC6P8FrVEMhdjE7n32Sn
         iHlKwHWwvll89VW7GKPNxJvK15XueSQ8E1WR4TpisHG4FV0/OHjFbqUI8/raDxp23ahg
         j18A==
X-Gm-Message-State: AC+VfDzH7/LQdst87G9Hu9Qbm2z58jPxCzQv6It28ppNG805JMr6LwXE
        0lNQtVHRiUvsINC/V/q86Hk=
X-Google-Smtp-Source: ACHHUZ6OtbsuuY2aXoeHYGi4XSA3mdaoGOU6p/4pXML9TF8F1ADk58bPj18ptJOfaGu5YjoBFEMRig==
X-Received: by 2002:a17:903:1250:b0:1b5:3c7f:1b3b with SMTP id u16-20020a170903125000b001b53c7f1b3bmr5150508plh.35.1687762601317;
        Sun, 25 Jun 2023 23:56:41 -0700 (PDT)
Received: from localhost (fpd11144dd.ap.nuro.jp. [209.17.68.221])
        by smtp.gmail.com with ESMTPSA id jg3-20020a17090326c300b001a2104d706fsm2559571plb.225.2023.06.25.23.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 23:56:40 -0700 (PDT)
Date:   Mon, 26 Jun 2023 15:56:39 +0900
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Jonas Bonn <jonas@southpole.se>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Stafford Horne <shorne@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, keyrings@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        openrisc@lists.librecores.org,
        linux-arm-kernel@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, linuxppc-dev@lists.ozlabs.org,
        x86@kernel.org
Subject: Re: [PATCH 00/24 v2] Documentation: correct lots of spelling errors
 (series 1)
Message-ID: <20230626065639.GA3403711@rocinante>
References: <20230209071400.31476-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209071400.31476-1-rdunlap@infradead.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,

> Correct many spelling errors in Documentation/ as reported by codespell.
> 
> Maintainers of specific kernel subsystems are only Cc-ed on their
> respective patches, not the entire series.
> 
> These patches are based on linux-next-20230209.
> 
[...]
>  [PATCH 13/24] Documentation: PCI: correct spelling
[...]

Applied to misc, thank you!

[1/1] Documentation: PCI: correct spelling
      https://git.kernel.org/pci/pci/c/b58d6d89ae02

	Krzysztof
