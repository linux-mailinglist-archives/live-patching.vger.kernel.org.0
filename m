Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6416D2F91
	for <lists+live-patching@lfdr.de>; Sat,  1 Apr 2023 11:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjDAJ7a (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 1 Apr 2023 05:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDAJ73 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 1 Apr 2023 05:59:29 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C35EE18F;
        Sat,  1 Apr 2023 02:59:28 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b20so99181546edd.1;
        Sat, 01 Apr 2023 02:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680343167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8OwNskOq/WB2ogrPeVhoUbqDTcGZFk0KDKVEoD0eJvA=;
        b=djYDNY7ILOyCIaQ3ynhdb6NTzFDRn4w512o8Dask1IPGpZOiVnFIAdGcyx0lZPUM1U
         IRAEtiictVQDX7eFMUk/atoUBaZiei5Iq/EofIxpQjQfEKOZnVw3QfNSjqTjHSQdWHqm
         wAufeUN0yVWRGCGxetpjp3kc6Nzal71vgK8Nd5yMItO8iYicCSOHu3ne20U0o6YSmssQ
         IsVnsE/k6EXYg98Q7EBzZYlICzeJB/0UYFWXXHknMbDJAX6neirI6ChQiRcgqxrmHwK0
         QR4HxTKyT6MforZCioaKdX77CN1eqQMKv1A16PAoKTUDcK8QHVw8mAjn/Pwvmn9DMi7C
         jtmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680343167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OwNskOq/WB2ogrPeVhoUbqDTcGZFk0KDKVEoD0eJvA=;
        b=reP6SHsZVJQGGTu5ChTN3jgNsquOVEoqhoEkegXEXX7J83HpGw1NCN/ntiUEMHsn9r
         uDFleeAy3dBZTKNUd5fIr5MDFIxuBrY8NrUieIydE3pxiTA7etFgoMdb3/VLakAeLsFf
         4I3IKQNIFjj6cWOBivFoBzqEuk7V09FGeX58apnLJldGl845kjkhU3Zfoxsh1c0TqDDH
         VPPJ/9T9XmXcqTZ+VBAPO0WaP7clCQqbDX6IIejT4z/vG/oOTK3eeA+qxLDeYO56lv7v
         l0E0fl6vcIPNVOb0bGnabpJLiAg1bOk63K9K1vyNvkmPF2IfGMvTORSPhDua3LbrPjow
         +aHA==
X-Gm-Message-State: AAQBX9e90NwVp1aGpotTJjLRkiwOH7bP61sGrENG/a8LkSQwZcAMZ5se
        +VkFeQsVa8UsewrivKPxZg==
X-Google-Smtp-Source: AKy350bVO6kZfY8iIuqS/9CJdE3MTB4p2zmqEXb7GJrIrsIYW/qVqqViAsRJuq7xwOfxiA4X1cytyQ==
X-Received: by 2002:a17:907:a586:b0:946:c60b:470b with SMTP id vs6-20020a170907a58600b00946c60b470bmr17147587ejc.63.1680343166687;
        Sat, 01 Apr 2023 02:59:26 -0700 (PDT)
Received: from p183 ([46.53.251.40])
        by smtp.gmail.com with ESMTPSA id gl25-20020a170906e0d900b00929fc8d264dsm1957803ejb.17.2023.04.01.02.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 02:59:26 -0700 (PDT)
Date:   Sat, 1 Apr 2023 12:59:24 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v7 00/10] livepatch: klp-convert tool
Message-ID: <0d28af49-ff04-417c-9047-fc2c796a5040@p183>
References: <4ce29654-4e1e-4680-9c25-715823ff5e02@p183>
 <683593a8-79db-4f3b-bc78-7917284683e4@p183>
 <f1351c5f-16aa-8407-753c-90049956123d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f1351c5f-16aa-8407-753c-90049956123d@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Mar 31, 2023 at 12:03:52PM -0400, Joe Lawrence wrote:
> On 3/30/23 13:04, Alexey Dobriyan wrote:
> > This patchset somehow breaks the build of the simplest livepatch module:
> > 
> > 	make -f linux/linux-1/scripts/Makefile.modfinal
> > 	make[1]: *** No rule to make target 'linux/module-klp/main.tmp.ko', needed by 'linux/module-klp/main.ko'.  Stop.
> > 
> 
> Thanks for testing.
> 
> Presumably this is an out-of-tree livepatch module?  If so, that is
> still on the TODO list.  If not, that is weird as the patchset itself
> includes updates to samples/ and lib/ livepatches that build and load fine.

Yes, this is external module.

make doesn't see this implicit rule despite it is hiding in the open:

	+%.tmp.ko: %.o %.mod.o symbols.klp FORCE
	+	+$(call if_changed,ld_ko_o)
