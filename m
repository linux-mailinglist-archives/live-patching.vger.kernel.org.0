Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D6F1EF8EC
	for <lists+live-patching@lfdr.de>; Fri,  5 Jun 2020 15:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgFENYx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 5 Jun 2020 09:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgFENYx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 5 Jun 2020 09:24:53 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2EEC08C5C2;
        Fri,  5 Jun 2020 06:24:53 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 5so2730505pjd.0;
        Fri, 05 Jun 2020 06:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jPqXVXtc79WvvXrvoTaGf7nAStvx0qycYwpo7dn0l7I=;
        b=po8SjU+xeLGS/x5kQxzffs1xCB73Sg6n7CKyBKbx6rFCIqftfj+iLPDSGxs3gz/h5E
         55cL4Euz5fojnDLCYjzMbz9jj6JisyyMvLR3bwt1FNhZQeB9H7V505d/TBPCHwOlEgra
         YV+r2rhgDzeAO2fxRfoq3ssckxu2VACyYNF/XS6h0ZKK1hQOpMEW+E02btINHF0jbksa
         d3qZgSMQU+f7nkfaXqZD/RTl9+0wy/vuF7yynwpk42lRWDSMYdslMbOhknpnmk296tOU
         UoDAdTP5gkYKcDvzWMOy8jNCQwZVql77xTqOXfDpXx2jc8wtuxYL+5H6QEIGZgYWn3mJ
         axFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=jPqXVXtc79WvvXrvoTaGf7nAStvx0qycYwpo7dn0l7I=;
        b=ETqfL/FZblo6OSv+Z2yLTG8EXGYyHtVlMo52ZDw8F9xtXX0tqiqAjiELsOnzXhAioU
         jcRvr22kIfLQxB4N72Y0aaijlGrj+j/zi2X28okNhrt3t/spAQCTua9xXorEhIYWPNMk
         n9nHFJMS8dtC5RO9kh7QPdemuQ2mdwILxhVbhiGMcLBoiTBiLqdUk2kytBLgeBCikPB6
         Q32LckUYOI7hNTMXD5OshmutLF6HS/275suRvOZMHljJTxwxYgMDXLSEV8gm/ZyivYPE
         f327g/0PKpbowvTsIjJ6DbSV3VrWtZs3uir0RgjxuSOhctYVFPjo+bVqdAYJLp3Mjtlj
         0ySw==
X-Gm-Message-State: AOAM531yv1y1e94wec6N/7RB0lVYN2sUia2Xk14zdeQtYr2vzWoEzsP4
        NeuYPy8K02+LzEFietUm5wg=
X-Google-Smtp-Source: ABdhPJzJ8umEQm9+tlcdEcU5noDuJ4Ha4pG1ay6Bymt+BZanw+lR+ILLP+FeTLOJdOKUIKbqD0eq4Q==
X-Received: by 2002:a17:902:7487:: with SMTP id h7mr9913280pll.155.1591363492420;
        Fri, 05 Jun 2020 06:24:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r1sm6609677pgb.37.2020.06.05.06.24.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Jun 2020 06:24:51 -0700 (PDT)
Date:   Fri, 5 Jun 2020 06:24:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v4 11/11] module: Make module_enable_ro() static again
Message-ID: <20200605132450.GA257550@roeck-us.net>
References: <cover.1588173720.git.jpoimboe@redhat.com>
 <d8b705c20aee017bf9a694c0462a353d6a9f9001.1588173720.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8b705c20aee017bf9a694c0462a353d6a9f9001.1588173720.git.jpoimboe@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Apr 29, 2020 at 10:24:53AM -0500, Josh Poimboeuf wrote:
> Now that module_enable_ro() has no more external users, make it static
> again.
> 
> Suggested-by: Jessica Yu <jeyu@kernel.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Acked-by: Miroslav Benes <mbenes@suse.cz>

Apparently this patch made it into the upstream kernel on its own,
not caring about its dependencies. Results are impressive.

Build results:
	total: 155 pass: 101 fail: 54
Qemu test results:
	total: 431 pass: 197 fail: 234

That means bisects will be all but impossible until this is fixed.
Was that really necessary ?

Guenter
