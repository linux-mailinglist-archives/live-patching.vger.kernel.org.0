Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824FE6B2CE7
	for <lists+live-patching@lfdr.de>; Thu,  9 Mar 2023 19:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjCISag (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Mar 2023 13:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCISaf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Mar 2023 13:30:35 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10F6EABBF;
        Thu,  9 Mar 2023 10:30:33 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id j11so10756164edq.4;
        Thu, 09 Mar 2023 10:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678386632;
        h=in-reply-to:references:subject:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4urQlGXr8lLq17WGtaGhswXCBsX5EW+r3M6mgsqTyI=;
        b=ovjWDmv4Ap8nOOitMzjcklX07UedzlN+7WXWqXR9oikjmjmvid0fHdowugb7+bueHH
         mD54YPL3axZRFnLh4lUi/5vc+XMAHWq3gHsfllVWH87PYOmEwG+4/BWeQ+4fGjqSwkCP
         qYVxazf5vuXsG21NTuC9WJFOt2BgsfK9MqIwDlWdkagLBYPgvKCIMuFASgYiPnFiJ6vS
         AIj46g46tiYOk14KkbQ3vV8LUhKPZPVy8m7SbCxJF3SwSqkGTf/f+kKpdhHYs5ZKT6Of
         d17sM08iHg3loOe26HSjGlSOZadrO13Y8NT5VQ2brpBm6YfbeQv+jv5zYPkz0QG5TH1I
         borg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678386632;
        h=in-reply-to:references:subject:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=V4urQlGXr8lLq17WGtaGhswXCBsX5EW+r3M6mgsqTyI=;
        b=gD1vsMoG7lMVNW3clcuOsALFgG6qM0Cc+p+4TXN0EkNz3BNehp5cSBIqQdmXWKNfqP
         0tX6Nn+fWu3dCMCyE8ylofTvdM/v7BX0O35FOevoFWr9GESvA7t3eQ+pYPI8cP3EByuH
         SgA4ZCMwFFqfukhg/p/AXYWMpkLOoLbtO47COvHK8IVib4E7cAL8lZL9hu0IMcWv+j1+
         rkUOt/yv9smk7tUYTsYFoMu5ehY3sSoeYDeuz5rhUWca/kNcufR6YBFr12/s+sdfHbWu
         ZkLNcw29L/oIbglCE+CwTw6GvKgrTXpi88cQ/bVlEEVgZF4lx1eTcRiUuPiSKBWsvzdP
         JJgA==
X-Gm-Message-State: AO0yUKWJtbVKKU/D2h0dRQ87hskOPBvTB2blCL6JHZVQMZfIXv+aZZlp
        Nw9OhLb/ERKuXl4IvyEBjDE=
X-Google-Smtp-Source: AK7set/CL7WxyYZfbx/czNNe8zzv7/nvtiCTsyGmkEqu68TNOIIpf/5nzg8TcPZ5HtIF31S3BeDoVg==
X-Received: by 2002:a17:906:5ca:b0:8f6:ad32:cd51 with SMTP id t10-20020a17090605ca00b008f6ad32cd51mr26136198ejt.62.1678386632294;
        Thu, 09 Mar 2023 10:30:32 -0800 (PST)
Received: from localhost ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id f3-20020a170906738300b008cf377e8795sm9167547ejl.199.2023.03.09.10.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 10:30:31 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 09 Mar 2023 19:30:30 +0100
Message-Id: <CR22ELPAP7ZX.TVASVAQNUS6S@vincent-arch>
From:   "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To:     "Zhen Lei" <thunder.leizhen@huawei.com>,
        "Luis Chamberlain" <mcgrof@kernel.org>,
        "Josh Poimboeuf" <jpoimboe@kernel.org>,
        "Jiri Kosina" <jikos@kernel.org>,
        "Miroslav Benes" <mbenes@suse.cz>,
        "Petr Mladek" <pmladek@suse.com>,
        "Joe Lawrence" <joe.lawrence@redhat.com>,
        "Jiri Olsa" <jolsa@kernel.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        <linux-trace-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-modules@vger.kernel.org>
Subject: Re: [PATCH] kallsyms: Delete an unused parameter related to
 {module_}kallsyms_on_each_symbol()
References: <20230308073846.1882-1-thunder.leizhen@huawei.com>
In-Reply-To: <20230308073846.1882-1-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> The parameter 'struct module *' in the hook function associated with
> {module_}kallsyms_on_each_symbol() is no longer used. Delete it.
>
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
