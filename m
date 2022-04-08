Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10314F9821
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 16:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiDHOgh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 8 Apr 2022 10:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236958AbiDHOgh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 8 Apr 2022 10:36:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9FF31EC9B5
        for <live-patching@vger.kernel.org>; Fri,  8 Apr 2022 07:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649428472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P7Egd3v0QGZRIC382enFxAdFYzTUSG9bvqRfc1sQGc4=;
        b=fSs++aU72P0llAXTnfadZlMhKDAFbZy715re3KcJynnMhIxWoNgTg92j9PwQhga8w0sXgB
        cCiVxv0/jJrYquph2Mh5EHgrgbpM77vbbnjJHHAfyM/I8JWG5Bc+cTn4tr1rbbqND11hHR
        XAeAWpRopv81WtU9m4KX+lfDBRzp5KE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-p4Bjp3ajO1-yH9jt4SzGQg-1; Fri, 08 Apr 2022 10:34:29 -0400
X-MC-Unique: p4Bjp3ajO1-yH9jt4SzGQg-1
Received: by mail-qt1-f200.google.com with SMTP id l12-20020ac84a8c000000b002ed0db96547so455829qtq.18
        for <live-patching@vger.kernel.org>; Fri, 08 Apr 2022 07:34:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P7Egd3v0QGZRIC382enFxAdFYzTUSG9bvqRfc1sQGc4=;
        b=n0IaBvN41MWu7wKndQnRII4kpZ1kg2IrG+wQDHIB1Hkpj/Qc41fv6pCPI4I7JRwJgC
         pq+lhKEpuikud7LtCLJ+q1/+5GomgX82P1PwG0hKcD0vHdN6HiZ/PcEP8lwYK0VuUcQG
         s7Sf9xQgoUxkFr7V6zyas5TyaZ1raXSzJCbDL7s1ku8xlVAzPLtjHgVqeOuIvkYgRep1
         mXkVyaMnRe7J38ISLwJETEvBlUO+v9d6GV8f6jktJ/49PxVD1oeD4GNZBlBz8dddBpEg
         aCUmQgp2Wmy5cwt5VIYfLG0E2TQIVTjUYdfUEyqxKvoHkKk3xUqCWSpNWmiEdQbIm4nI
         jzNQ==
X-Gm-Message-State: AOAM531qn5p6JQxny0RXEaPqozyUeXapmUK/bMN0Ow9HKa73rCzMbGhP
        wMkrhwxADO20Roil0eK4Q7et6CbcvzNVAuPHpCstlbYsNCqB0AjvcwaHYDQ20XKPAS36XcwYVCy
        DOPHMYqaJ7fk6m3w+jQ6/EaLsaw==
X-Received: by 2002:a05:6214:2684:b0:443:ce3d:5295 with SMTP id gm4-20020a056214268400b00443ce3d5295mr16444347qvb.57.1649428469345;
        Fri, 08 Apr 2022 07:34:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKRnK9m8ieH98Tqid9txPJskujy0WAzGUcIuDCsqcanpH5Ldlx9htehVTz0Pa2DWTYmypCmA==
X-Received: by 2002:a05:6214:2684:b0:443:ce3d:5295 with SMTP id gm4-20020a056214268400b00443ce3d5295mr16444336qvb.57.1649428469151;
        Fri, 08 Apr 2022 07:34:29 -0700 (PDT)
Received: from treble ([2600:1700:6e32:6c00::15])
        by smtp.gmail.com with ESMTPSA id c11-20020a05620a134b00b006809a92a94fsm13166046qkl.79.2022.04.08.07.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 07:34:28 -0700 (PDT)
Date:   Fri, 8 Apr 2022 07:34:25 -0700
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     madvenka@linux.microsoft.com, mark.rutland@arm.com,
        broonie@kernel.org, ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Message-ID: <20220408143425.iovzmmdxxh77rjtz@treble>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <YlAUj6w6fePEo7v+@hirez.programming.kicks-ass.net>
 <YlAidG0qYe+yh/vg@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YlAidG0qYe+yh/vg@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 08, 2022 at 01:54:28PM +0200, Peter Zijlstra wrote:
> On Fri, Apr 08, 2022 at 12:55:11PM +0200, Peter Zijlstra wrote:
> > On Thu, Apr 07, 2022 at 03:25:09PM -0500, madvenka@linux.microsoft.com wrote:
> > 
> > > [-- application/octet-stream is unsupported (use 'v' to view this part) --]
> > 
> > Your emails are unreadable :-(
> 
> List copy is OK, so perhaps it's due to how Josh bounced them..

Corporate email Mimecast fail when I bounced them, sorry :-/

-- 
Josh

