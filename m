Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603D4474ACA
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 19:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbhLNS1C (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Dec 2021 13:27:02 -0500
Received: from mail-qk1-f171.google.com ([209.85.222.171]:35820 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbhLNS1B (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Dec 2021 13:27:01 -0500
Received: by mail-qk1-f171.google.com with SMTP id m192so17638641qke.2;
        Tue, 14 Dec 2021 10:27:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r7/eSKc1fwQEoP6HEuM+9k2KWpBjoOGeqK78q4eFlgc=;
        b=NWXSZGDzTpPnMpWzvIGm3Dzew9rPuO5QU4rbzgh+mPiUDt4yLWIiay2K5dp0zB7Dxj
         BgCfBezxD7LRtr9vA9Ayf/OLI+Kx97vrnMqCOoguBxFix9mNQUOtN2Pm64HjmNM2s7F6
         N3i6N3fsjL4EPcseGs5DnYpDj3FdKy96eMzBFS4DjH0NBPtcwZhe+6tZ2RqE1CKHXhhp
         O/n6x7JrzJuTpsT57izfHu6P1VwxSQvPJTsakxJqGvJnrN+bJ1ltxIF3w9tVywRyXfTi
         NT7RULwbLJLlzRh3xTY4inmj47Z+C9HE4M8TAjzereDhcW7RVPOd8gw965MbJTs1s+mD
         n8PA==
X-Gm-Message-State: AOAM531aYp+sTBSLEBGXPbA/EL15INAWwMyfVjVl9cp9dGvTUE/1ymig
        zg8mnzdC+GHlWjEApBJP4Z4=
X-Google-Smtp-Source: ABdhPJyvrBJM0N7Ha6O2IkmrWXXF22HMy8oYZgIfD/VtG1+owbPPkp9wDtMpQSYcl+18bOGKqw1dnw==
X-Received: by 2002:a05:620a:4081:: with SMTP id f1mr5434583qko.165.1639506420556;
        Tue, 14 Dec 2021 10:27:00 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-022.fbsv.net. [2a03:2880:20ff:16::face:b00c])
        by smtp.gmail.com with ESMTPSA id z13sm371219qkj.1.2021.12.14.10.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 10:27:00 -0800 (PST)
Date:   Tue, 14 Dec 2021 10:26:58 -0800
From:   David Vernet <void@manifault.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, yhs@fb.com,
        songliubraving@fb.com
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <Ybjh8qurXP7A0/5A@dev0025.ash9.facebook.com>
References: <20211213191734.3238783-1-void@manifault.com>
 <YbhZwVocHDX9ZBAc@alley>
 <Ybi9yeEnKqq7HtS5@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybi9yeEnKqq7HtS5@kroah.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote on Tue [2021-Dec-14 16:52:41 +0100]:
> You are FORCED TO call kobject_put() after kobject_init() is called.
> Anything else is a bug.

Ack, thanks for confirming, Greg. I'll send out a v2 of the patch that fixes the
leak and addresses the issue that Josh identified.

- David
